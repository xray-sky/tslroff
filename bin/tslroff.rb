#! /usr/bin/env ruby
#
# tslroff.rb
#
# Created by R. Stricklin <bear@typewritten.org> on 05/10/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# convert troff source to HTML, to be formatted as much as possible by CSS.
# presentation should approach typesetter quality
# preserve as much as possible stuff going on in tmac.an, though this may
# be a manual step.
#
# convert nroff output to HTML; terminal quality results
# for platforms that do not ship sources.
#
# eventually, support rewriting HTML for site-specific standards
# (AIX, BeOS, etc.), Domain/OS or VMS help files, etc.
#
# remember, remember https://github.com/bbatsov/ruby-style-guide
#

require 'date'
require 'nokogiri'
#require 'ruby-prof'
#RubyProf.start

require_relative '../lib/classes/manual.rb'

assets = File.realpath("#{__dir__}/../lib/assets")
#$CSS   = File.realpath("#{assets}/tslroff.css")
# chrome won't load css from a file under chomedriver control??!
$CSS = "http://dev.online.typewritten.org/Manual/tslroff.css"
filelist = []
outdir = '.'
os = ver = ''

args = ARGV.each
loop do
  begin
    arg = args.next
    case arg
    when '-os'   then os = args.next
    when '-ver'  then ver = args.next
    when '-odir' then outdir = args.next
    else
      # I need these File tests to _not_ follow symbolic links.
      # The select block checks for symlink first, to avoid file? following symlinks.
      # literal [] (and some other characters) need escaping from Dir.glob (".../BeOS[doc]/...")
      filelist += File.lstat(arg).directory? ? Dir.glob(Regexp.escape(arg) + '/**').select { |f| File.symlink?(f) or File.file?(f) } : [arg]
    end
  rescue StopIteration
    break
  end
end

raise ArgumentError, 'need an input file!' if filelist.empty?
template = File.read("#{assets}/manual.erb")

files = filelist.sort.each
loop do
  file = files.next
  ifile = File.basename(file)
  src = Manual.new(file, os, ver)

  odir = "#{outdir}/#{src.output_directory}"
  #ofile = "#{odir}/#{src.manual_entry}.#{src.manual_section}.html" # TODO needs 50% more directory structure. get it back from Manual after parsing (name, section).
  ofile = "#{odir}/#{src.manual_entry}.html" # TODO needs 50% more directory structure. get it back from Manual after parsing (name, section).
  system('mkdir', '-p', odir) unless Dir.exists?(odir)

  if src.symlink?
    new_link = src.retarget_symlink
    begin
      File.symlink(new_link[:target], "#{odir}/#{new_link[:link]}") if new_link
    rescue Errno::EEXIST
      File.delete "#{odir}/#{new_link[:link]}"
      retry
    rescue Errno::EINTR => e
      warn "retry symlink (#{e.message})"
      sleep 1
      retry
    end
  else
    page = src.to_html
    related = src.magic == :HTML ? [] : Nokogiri::HTML(page).search('a[@href]')

    loopcontext = binding

    # forking is more to keep 'erb' from polluting my string methods than it is
    # for "performance"
    pid = fork do
      # whoa hoss, why does requiring this at the top break my string parsing?!
      require 'erb'
      File.open(ofile, File::CREAT|File::TRUNC|File::WRONLY, 0644) do |file|
        file.write(ERB.new(template).result(loopcontext))
      end
      exit
    end
    Process.detach(pid)
  end

  #result = RubyProf.stop
  #RubyProf::FlatPrinter.new(result).print(STDOUT)
  #RubyProf::GraphPrinter.new(result).print(STDOUT, {})

  rescue ManualIsBlacklisted => e
    warn "#{ifile}: skipping (blacklist) -- #{e.message}"
  rescue FileIsEmptyError, IOError, SystemCallError => e
    warn "#{ifile}: #{e.message}"
  rescue StopIteration
    break
  rescue => e
    warn "#{ifile}: unhandled exception #{e.message}\n#{e.backtrace.join("\n")}"
end

