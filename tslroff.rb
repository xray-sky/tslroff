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

assets = __dir__ + '/assets'
$LOAD_PATH << File.dirname(__FILE__)
$CSS = assets + '/tslroff.css'

require 'date'
require 'nokogiri'
require 'classes/manual.rb'

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
      filelist += File.directory?(arg) ? Dir.glob(arg + '/**').select { |f| File.file?(f) } : [arg]
    end
  rescue StopIteration
    break
  end
end

raise ArgumentError, 'need an input file!' if filelist.empty?

files = filelist.each
loop do
  begin
    file = files.next
    unless File.readable?(file)
      warn "can't read #{file}"
      next
    end
    ifile = File.basename(file)
    src = Manual.new(file, os, ver)
    page = src.to_html
    related = Nokogiri::HTML(page).search('a')

    odir = "#{outdir}/#{src.output_directory}"
    ofile = "#{odir}/#{src.manual_entry}.#{src.manual_section}.html" # TODO needs 50% more directory structure. get it back from Manual after parsing (name, section).
    system('mkdir', '-p', odir) unless Dir.exists?(odir)

    loopcontext = binding

    # forking is more to keep 'erb' from polluting my string methods than it is
    # for "performance"
    pid = fork do
      # whoa hoss, why does requiring this at the top break my string parsing?!
      # this needs resolving before we can deal with multiple files per invokation
      require 'erb'
      #out = ERB.new(File.read("#{assets}/manual.erb")).result(loopcontext)
      File.open(ofile, File::CREAT|File::TRUNC|File::WRONLY, 0644) do |file|
        file.write(ERB.new(File.read("#{assets}/manual.erb")).result(loopcontext))
      end
      exit
    end
    Process.detach(pid)

  rescue FileIsLinkError
    target = $!.to_s
    File.symlink("#{target}.html", "#{ifile}.html") # TODO wrong
  rescue StopIteration
    break
  end
end

