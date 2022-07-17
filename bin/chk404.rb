#! /usr/bin/env ruby
#
# chk404.rb
#
# Created by R. Stricklin <bear@typewritten.org> on 05/15/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# scan a file/directory hierarchy for html output of tslroff;
# review "related articles" for 404s and report
#
# TODO make it check targets of symlinks too?
#

#$LOAD_PATH << File.dirname(__FILE__)

require 'nokogiri'

filelist = ARGV.collect do |arg|
  # TODO make this actually recursive
  File.directory?(arg) ? Dir.glob(arg + '/**').select { |f| File.ftype(f) == 'file' } : arg
end.flatten

raise ArgumentError, 'need an input file!' if filelist.empty?

filelist.each do |file|
  basedir = File.dirname(file)
  doc = Nokogiri::HTML(File.new(file))
  doc.css('#man a').each do |link|
    warn "#{file}: #{link.text.strip}" unless File.exists?("#{basedir}/#{link['href']}")
  end
end
