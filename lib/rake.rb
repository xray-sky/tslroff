# rake.rb
#
# Rakefile utility methods
#
# TODO
# √ logfiles
# √ cache stats
# √ debug operation
#   symlinks
#   indexing
#   comments

require 'erb'
require 'date'
require 'nokogiri'

$ttyerr = $stderr.dup

class Rake::NameSpace
  def namespaces
    tasks.map do |t|
      depth = @scope.to_a.count
      h = t.name.split(':')
      h[depth] if h.length > depth + 1
    end.compact.sort.uniq
  end

  def scope_name
    @scope.to_a.reverse.join(':')
  end
end

def openBuildLogTask odir
  log = "build_#{Time.now.strftime('%Y%m%d_%H%M%S')}.log"
  $stderr.reopen("#{odir}/#{log}", 'w', flags: File::CREAT)
end

def closeBuildLogTask
  $stderr.reopen($ttyerr)
end

def collectionNamespace name, &block
  nsn = namespace name do |n|
    yield if block_given?
    t = task :all => []
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

def manualNamespace name, sources: nil, idir: nil, odir: nil, vendor_class: nil, &block
  unless odir
    #warn "No output directory given for #{name} (skipped)"
    return nil
  end
  idir ||= odir.downcase

  namespace name do |n|
    t = task :all, [:limit] do |_t, args|
      puts "Making #{n.scope_name}#{" (limit: #{args[:limit]})" if args[:limit]}"
      start_time = Time.now
      directory("#{Docroot}/#{odir}").invoke
      openBuildLogTask "#{Docroot}/#{odir}" unless args[:limit]
      pagecount = collectionTask sources, idir, odir, limit: args[:limit], vendor_class: vendor_class
      closeBuildLogTask unless args[:limit]
      puts "       #{n.scope_name} => #{pagecount} pages complete in #{(Time.now - start_time)}s"
      puts "       #{Troff.webdriver.cache_stats}" if Troff.webdriver
      Troff.webdriver&.reset_cache_stats
    end
    yield(task: t, idir: "#{Srcroot}/#{idir}", odir: "#{Docroot}/#{odir}") if block_given?
  end
end

def collectionTask sources, srcdir, outdir, limit: nil, vendor_class: nil, source_args: {}
  pagecount = 0
  sources.each do |src|
    fl = FileList["#{Srcroot}/#{srcdir}/#{src}"]
    fl.exclude do |f|
      f unless File.basename(f).match?(limit)
    end if limit
    fl.each do |s|
      # may have contained directory wildcards
      if File.lstat(s).directory?
        dfl = FileList["#{s}/*"]
        dfl.exclude do |f|
          f unless File.basename(f).match?(limit)
        end if limit
        dfl.each do |f|
          # TODO symlinks - checked first to avoid file? from following them
          warn "symlink #{f} (skipped)" and next if File.symlink?(f)
          pagecount += 1
          manualTask(f, outdir, vendor_class: vendor_class, source_args: source_args) and next if File.file?(f)
        end
      else
        # TODO symlinks - checked first to avoid file? from following them
        warn "symlink #{s} (skipped)" and next if File.symlink?(s)
        pagecount += 1
        manualTask(s, outdir, vendor_class: vendor_class, source_args: source_args) if File.file?(s)
      end
    end
  end
  warn Troff.webdriver.cache_stats if Troff.webdriver
  pagecount
end

def manualTask source, basedir, vendor_class: nil, source_args: {}
  srcfile = File.basename(source)
  k = Kernel.const_defined?("#{vendor_class}::Manual") ? Kernel.const_get("#{vendor_class}::Manual") : ::Manual
  man = k.new source, vendor_class: vendor_class, source_args: source_args
  page = man.to_html
  title = man.manual_entry || srcfile.tap { |x| "falling back to src filename #{srcfile.inspect} (no title)" }
  title = srcfile and warn "falling back to src filename #{srcfile.inspect} (title empty)" if title.empty?
  section = man.manual_section
  # can't find section? output to parent dir
  # TODO busted as hell for HTML, Aegis help, etc.
  odir = (section and !section.empty?) ? "#{Docroot}/#{basedir}/man#{section.downcase}" : "#{Docroot}/#{basedir}"
  related = man.magic == :HTML ? [] : Nokogiri::HTML(page).search('a[@href]')  # TODO better

  directory(odir).invoke
  file "#{odir}/#{title}.html" do |t|
    taskcontext = binding
    File.open(t.name, File::CREAT|File::TRUNC|File::WRONLY, 0o644) do |f|
      f.write ERB.new(Template, trim_mode: '-').result(taskcontext)
    end
  end.invoke

rescue ManualIsBlacklisted => e
  warn "#{srcfile}: skipping (blacklist) -- #{e.message}"
rescue FileIsEmptyError, IOError, SystemCallError => e
  warn "#{srcfile}: #{e.message}"
rescue StopIteration
  warn "#{srcfile}: #{e.message}"
rescue => e
  warn "#{srcfile}: unhandled exception #{e.message}\n#{e.backtrace.join("\n")}"
end

def assetsTask sources, idir, odir, cut_dirs: 0, postprocess: nil
  task :assets do
    Dir.glob sources.map { |g| "**/#{g}" }, base: idir do |asset|
      adir = File.dirname(asset).split('/')
      adir = "#{odir}/#{adir[(cut_dirs)..-1].join('/')}"
      afile = "#{adir}/#{File.basename asset}"
      directory(adir).invoke
      file afile => "#{idir}/#{asset}" do |t|
        cp t.source, t.name
        chmod 0o644, t.name
        send postprocess, t.name if postprocess
        touch t.name  # macbinary decode resets mtime, defeats rake "freshness"
      end.invoke
    end
  end
end

def processMacBinary f
  system %(macbinary probe "#{f}" && macbinary decode -o tmp "#{f}" && mv tmp "#{f}")
end
