# rake.rb
#
# tslroff Rakefile utility methods
#
# TODO
# √ logfiles
# √ cache stats
# √ debug operation
#   symlinks
#   indexing
#   comments
#   leverage Pathname class and/or String.pathmap method?
#
# frozen_string_literal: true
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
# the generated "all" task can be sent an optional pattern that will limit the build
# to just those filenames (minus parent directories) matching (regex) the pattern.
# If the build is limited in this way, stderr is not redirected to the build log file.
#
# extra build tasks (e.g. copying static assets) can be generated for this collection of manuals
# by passing a block which receives as arguments idir, odir, and the :all task object.
#
# TODO optional ruby profiling of build job
#

def manual_namespace(name, sources: nil, idir: nil, odir: nil, vendor_class: nil, &block)
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
      pagecount = collection_task sources, srcdir, pubdir, limit: args[:limit], vendor_class: vendor_class
      close_build_log_task unless args[:limit]
      puts "       #{scope} => #{pagecount} pages complete in #{Time.now - start_time}s"
      puts "       #{Troff.webdriver.cache_stats}" if Troff.webdriver
      Troff.webdriver&.reset_cache_stats
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

def collection_task(sources, srcdir, pubdir, limit: nil, vendor_class: nil, source_args: {})
  pagecount = 0
  # need to cover both file and directory wildcards
  fl = FileList.new(sources.map { |s| [ "#{srcdir}/#{s}", "#{srcdir}/#{s}/*" ] }.flatten)
  fl.each do |src|
    next if File.directory?(src)
    next if limit and !File.basename(src).match?(limit)
    # TODO symlinks - checked first to avoid file? from following them
    warn "symlink #{src} (skipped)" and next if File.symlink?(src)
    puts "<== #{src}" if limit
    pagecount += 1
    manual_task(src, pubdir, vendor_class: vendor_class, source_args: source_args)
  end
  warn Troff.webdriver.cache_stats if Troff.webdriver
  pagecount
end

# Build an individual manual entry
#

def manual_task(source, pubdir, vendor_class: nil, source_args: {})
  srcfile = File.basename(source)
  k = Kernel.const_defined?("#{vendor_class}::Manual") ? Kernel.const_get("#{vendor_class}::Manual") : ::Manual
  man = k.new source, vendor_class: vendor_class, source_args: source_args
  page = man.to_html
  title = man.manual_entry || srcfile.tap { |x| warn "falling back to src filename #{x.inspect} (no title)" }
  title = srcfile and warn "falling back to src filename #{srcfile.inspect} (title empty)" if title.empty?
  section = man.manual_section
  # can't find section? output to parent dir
  # TODO busted as hell for HTML, Aegis help, etc.
  #      need to maintain some extra structure, not force man*/, etc.
  #odir = (section and !section.empty?) ? "#{pubdir}/man#{section.downcase}" : "#{pubdir}"
  odir = "#{pubdir}/#{man.output_directory}"
  related = man.magic == :HTML ? [] : Nokogiri::HTML(page).search('a[@href]') # TODO better

  directory(odir).invoke
  taskcontext = binding
  # prevent these from masking the apache file index (TODO not necessary once we are building our own indices)
  title = '_index'   if title == 'index'   and man.magic != :HTML
  title = '_default' if title == 'default' and man.magic != :HTML
  File.open("#{odir}/#{title}.html", File::CREAT | File::TRUNC | File::WRONLY, 0o644) do |f|
    f.write ERB.new(TEMPLATE, trim_mode: '-').result(taskcontext)
  end
rescue ManualIsBlacklisted => e
  warn "#{srcfile}: skipping (blacklist) -- #{e.message}"
rescue StopIteration, FileIsEmptyError, IOError, SystemCallError => e
  warn "#{srcfile}: #{e.message}"
rescue => e
  warn "#{srcfile}: unhandled exception #{e.message}\n#{e.backtrace.join("\n")}"
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
