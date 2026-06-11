# frozen_string_literal: true
# encoding: UTF-8
#
# rake.rb
#
# tslroff Rakefile utility methods
#
# TODO
# √ logfiles
# √ cache stats
# √ debug operation
#   symlinks (REVIEW decision on indexing on filename vs. on manual name; symlinks may not matter?)
# ~ indexing
#   comments
#   leverage Pathname class and/or String.pathmap method?
#   generic metadata insertion (e.g. contribution credits to TUHS)
#

require 'erb'
require 'date'
require 'nokogiri'

# demand-redirect $stderr to build log
#
# TODO reliance on logging via warn/stderr is preventing us from exploiting rake -m
#

$ttyerr = $stderr.dup

def open_build_log_task(odir)
  log = "build_#{Time.now.strftime('%Y%m%d_%H%M%S')}.log"
  $stderr.reopen("#{odir}/#{log}", 'w', flags: File::CREAT)
end

def close_build_log_task
  $stderr.reopen($ttyerr)
end

###
### Namespace and Task generators
###

# Automatically generate namespaces and corresponding "build all" tasks
# (typically, vendor & vendor->os hierarchy)
#
# Creates:
#  - a namespace with `name`
#  - a corresponding task, `name` with prerequisites:
#     + `name`:all
#     + on each enclosed namespace:
#        * a corresponding task, `name`, with prerequisites `name`:all
#  - the task, `name`:all
#
# TODO this defines non-top-level namespace tasks twice, once in the
#      yield and then again in n.namespaces.each. it works, but is ugly
#      (and explains e.g. x.clear_comments)
#

def collection_namespace(name, &block)
  nsn = namespace name do |n|
    yield if block_given?
    t = task all: []
    n.namespaces.each do |ns|
      x = task ns => "#{n.scope_name}:#{ns}:all"
      x.clear_comments
      x.comment = "Build all #{name} #{ns} manuals"
      t.prerequisites << x
    end
  end
  desc "Build all #{name} manuals"
  task name => "#{nsn.scope_name}:all"
  # add to top level all: task prerequisites - TODO doesn't work. figure it out, bozo
  #Rake::Task["#{Rake.application.current_scope.to_a.reverse.join(':')}:all"].enhance [name]
end

# Automatically generate a namespace and build task for a specific
# collection of manuals (typically, vendor->os->version)
#
# Creates:
#  - a namespace with `name`
#  - a corresponding task, `name`:all which causes
#     + all manuals specified by combining `idir` and `sources` to be built into `odir`
#        * imperatively: always builds all manuals (subject to `limit`, see below), every time
#     + all stderr captured in a build log file.
#     + build statistics to be sent to stdout
#
# The generated "all" task can be sent an optional pattern that will limit the build
# to just those filenames (ignoring parent directories) matching the pattern (regex).
# If the build is limited in this way, stderr is not redirected to the build log file.
# This is intended to facilitate debugging.
#
# Extra build tasks (e.g. copying static assets) can be generated for this collection of manuals
# by passing a block which receives as arguments idir, odir, and the :all task object.
#
# TODO optional ruby profiling of build job
#

def manual_namespace(name, sources: nil, idir: nil, odir: nil, os: nil, ver: nil, vendor_class: nil, entry_page: nil, &block)
  unless odir
    #warn "No output directory given for #{name} (skipped)"
    return nil
  end
  srcdir = "#{SRCROOT}/#{idir || odir.downcase}"
  pubdir = "#{PUBROOT}/#{odir}"

  namespace name do |n|
    scope = n.scope_name
    t = task :all, [:limit] do |_t, args|
      puts "Making #{scope}#{" (limit: #{args[:limit]})" if args[:limit]}"
      start_time = Time.now
      directory(pubdir).invoke
      open_build_log_task pubdir unless args[:limit]
      pagecount = collection_task sources, srcdir, pubdir, limit: args[:limit], vendor_class: vendor_class, os: (os or n.scope.take(2).last), ver: (ver or name), entry_page: entry_page
      close_build_log_task unless args[:limit]
      puts "       #{scope} => #{pagecount} pages complete in #{Time.now - start_time}s"
      puts "       #{Troff.webdriver.cache_stats}" if Troff.webdriver
      puts "       #{VMS::Help.webdriver.cache_stats}" if VMS::Help.webdriver
      Troff.webdriver&.reset_cache_stats
      VMS::Help.webdriver&.reset_cache_stats
    end
    yield(task: t, idir: srcdir, odir: pubdir) if block_given?
  end
end

# Generate an :assets task, which deploys static file assets into the pub tree
# Maintains directory structure from `sources`, optionally flattening some number
# of directories out of the hierarchy.
#
#   e.g. source = "test/foo/graphics/*.gif" with cut_dirs: 2
#          => would deploy to odir/graphics/*.gif
#
# Extra file processing can be performed by passing postprocess: a method
# which accepts the destination file name as an argument
#
# Unlike the collection_task and manual_task, this task only copies missing
# or updated assets.
#

def assets_task(sources, idir, odir, cut_dirs: 0, postprocess: nil)
  task :assets do
    Dir.glob sources.map { |g| "**/#{g}" }, base: idir do |asset|
      adir = File.dirname(asset).split('/')
      adir = "#{odir}/#{adir[cut_dirs..-1].join('/')}"
      afile = "#{adir}/#{File.basename asset}"
      directory(adir).invoke
      file afile => "#{idir}/#{asset}" do |t|
        cp t.source, t.name
        chmod 0o644, t.name
        send postprocess, t.name if postprocess
      end.invoke
    end
  end
end

###
### Build methods
###

# Build a collection of manuals
#
# Iterate over list of sources (likely including wildcards and directories to process)
# to find all manual files (excluding those not matching `limit` pattern, if provided).
# All manuals in the collection (subject to limit) are built, always.
#
# Returns:
#  - number of pages built
#
# Logs cache stats to stderr/build log on completion.
#
# TODO something useful re: symlinks
# REVIEW is this working correctly on directory structures more than one level deep?
#

def collection_task(sources, srcdir, pubdir, limit: nil, vendor_class: nil, entry_page: nil, source_args: {}, os: nil, ver: nil)
  pagecount = 0
  # need to cover both file and directory wildcards
  fl = FileList.new(sources.map { |s| [ "#{srcdir}/#{s}", "#{srcdir}/#{s}/*" ] }.flatten)
  ix = {}

  if ENV['RUBY_PROFILE']
    prof = RubyProf::Profile.new
    prof.start
  end

  fl.each do |src|
    next if File.directory?(src)
    next if limit and !File.basename(src).match?(limit)
    # TODO symlinks - checked first to avoid file? from following them
    #warn "symlink #{src} (skipped)" and next if File.symlink?(src)
    puts "<== #{src}" if limit
    pagecount += 1
    (sec, fl, nmlst, dsc) = manual_task(src, pubdir, vendor_class: vendor_class, source_args: source_args, os: os, ver: ver)
    ix[sec] ||= {}
    ix[sec][fl] = { names: nmlst&.split(/\s*,\s*/), description: dsc }
  end

  if ENV['RUBY_PROFILE']
    profile_results = prof.stop
    RubyProf::FlatPrinter.new(profile_results).print($stdout)
    #RubyProf::GraphPrinter.new(profile_results).print($stdout, {})
    #RubyProf::GraphHtmlPrinter.new(profile_results).print(File.open "graph.html", "w")
  end

  if Troff.webdriver
    warn Troff.webdriver.cache_stats
    Troff.webdriver.persist_cache
  end

  if VMS::Help.webdriver
    warn VMS::Help.webdriver.cache_stats
    VMS::Help.webdriver.persist_cache
  end

  #section_names = Kernel.const_defined?("#{vendor_class}::MANUAL_SECTION_NAMES") ? Kernel.const_get("#{vendor_class}::MANUAL_SECTION_NAMES") : {}
  section_names = vendor_class&.respond_to?(:name_for_section) ? vendor_class.method(:name_for_section) : proc { |x| x }
  index_task(ix, "#{pubdir}/#{'_' if entry_page == 'index.html'}index.html", os: os, ver: ver, names: section_names) unless limit
  pagecount
end

def index_task(ixinfo, idxfile, os: nil, ver: nil, names: proc { |x| x })
  ident = "#{os} #{ver}".strip
  ixf = File.open(idxfile, 'w')
  ixf.write ERB.new(INDEX_TEMPLATE, trim_mode: '-').result_with_hash(ixinfo: ixinfo.reject { |k,v| k == '!!!' }, names: names, ident: ident, page_title: "Manual &mdash; #{ident}")
  ixf.close
end

# Build an individual manual entry
#

def manual_task(source, pubdir, vendor_class: nil, source_args: {}, os: nil, ver: nil)
  ppid = Process.pid
  srcfile = File.basename(source)
  k = Kernel.const_defined?("#{vendor_class}::Manual") ? Kernel.const_get("#{vendor_class}::Manual") : ::Manual
  man = k.new source, vendor_class: vendor_class, source_args: source_args, os: os, ver: ver
  page = man.to_html

  title = String.new
  related = []
  indexing = []

  if page.is_a?(Array) # page bundle (e.g. from VMSHelpLibrary)
    page.reverse.each do |p|
      next if p[0].end_with? '/' # h4x - getting an empty file from VMSHelpLibrary somewhere causing "foo.hlb.html" REVIEW TODO
      page = p[1]
      title = File.basename p[0]
      mdir = File.dirname p[0]
      related = Nokogiri::HTML(page).search('a[@href]') unless man.magic == :HTML

      odir = "#{pubdir}/#{man.output_directory}#{"/#{mdir}" unless mdir == '.'}"
      directory(odir).invoke
      taskcontext = binding
      File.open("#{odir}/#{title}.html", File::CREAT | File::TRUNC | File::WRONLY, 0o644) do |f|
        f.write ERB.new(MANUAL_TEMPLATE, trim_mode: '-').result(taskcontext)
      end
    end # ending loop with page <= page[0][1], for normal indexing of only first entry (correct for VMSHelpLibrary)
  else # normal String return
    title = man.manual_entry || srcfile.tap { |x| warn "falling back to src filename #{x.inspect} (no title)" }
    title = srcfile and warn "falling back to src filename #{srcfile.inspect} (title empty)" if title.empty?
    # prevent these from masking the apache file index (TODO not necessary once we are building our own indices)
    #title = '_index'   if title == 'index'   and man.magic != :HTML
    #title = '_default' if title == 'default' and man.magic != :HTML
    related = Nokogiri::HTML(page).search('a[@href]') unless man.magic == :HTML

    odir = "#{pubdir}/#{man.output_directory}"
    directory(odir).invoke
    taskcontext = binding
    File.open("#{odir}/#{title}.html", File::CREAT | File::TRUNC | File::WRONLY, 0o644) do |f|
      f.write ERB.new(MANUAL_TEMPLATE, trim_mode: '-').result(taskcontext)
    end
  end

  # TODO better - indexing
  unless man.magic == :HTML
    html = Nokogiri::HTML(page)
    if man.index_name
      indexing = [[man.index_name, man.index_description]]
    else
      indexing = html.search('p[@class="name"]').map do |e|
        # how to about??
        # looks like Nokogiri.text() gives us the UTF-8 character rather than the HTML entity... &minus;, &nbsp;...
        # REVIEW maybe this should be created during text processing and queryable from the
        #        man object, so we can do something overrideable by vendor class. for now though.
        #        also how regular is this going to be?? catman -w known to have crazy results for
        #        ill formed manual entries so it's not solely an us problem.
        #(names, _sep, descr) = e.text.strip.partition(/[\s ]*(?:-|−)[\s ]*/) # hyphen &minus; &nbsp;
        (names, _sep, descr) = e.text.strip.partition(/(?:[\s ]+-[\s ]+|[\s ]*(?:−|—)[\s ]*)/) # hyphen (with spaces only) &minus; &mdash; &nbsp;
        [names, descr]
      end
    end
    #related = html.search('a[@href]')
  else
    # HTML indexing
    indexing = [[man.index_name, man.index_description]]
  end

  #exit unless Process.pid == ppid # guard against fork (i.e. VMS Help)
  warn "multi-line index info for #{title}.html" if indexing[1]
  [ "#{man.manual_section}", "#{man.output_directory}/#{title}.html", "#{indexing[0]&.[](0)}", "#{indexing[0]&.[](1)}" ]# REVIEW experimental

rescue ManualIsBlacklisted => e
  warn "#{srcfile}: skipping (blacklist) -- #{e.message}"
  [ "!!!", srcfile, title, "!! blacklisted #{srcfile}" ]
rescue StopIteration, FileIsEmptyError, IOError, SystemCallError => e
  warn "#{srcfile}: #{e.message}"
  [ "!!!", srcfile, title, "[[empty]] #{srcfile}" ]
rescue => e
  warn "#{srcfile}: unhandled exception #{e.message}\n#{e.backtrace.join("\n")}"
  [ "!!!", srcfile, title, "((exception)) #{srcfile}" ]
end

###
### assets task postprocessing methods
###

# Decode MacBinary format files.
#
# Necessary for the BeOS R3 manual.
#

def process_macbinary(f)
  tmpfile = "#{File.dirname f}/zztmp"
  # macbinary decode resets mtime, defeats rake "freshness"
  system %(macbinary probe "#{f}" \
           && macbinary decode -o "#{tmpfile}" "#{f}" \
           && touch "#{tmpfile}" \
           && rm "#{f}" \
           && mv "#{tmpfile}" "#{f}")
end
