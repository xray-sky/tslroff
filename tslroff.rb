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
# eventually, support rewriting HTML for site-specific standards. 
# (AIX, BeOS, etc.)
#

$LOAD_PATH << File.dirname(__FILE__)
require 'modules/Manual.rb'
#require 'nokogiri'


# TODO: parse arguments properly
raise ArgumentError, 'need an input file!' if ARGV[0].nil?


cwd = Dir.getwd
(ipath,ifile) = ARGV[0].scan(%r|^(.+)/(.+)$|)[0]
#Dir.chdir(ipath)

begin
  src = Manual.new(ARGV[0])
rescue FileIsLinkError
  target = $!.to_s
  File.symlink("#{target}.html", "#{ifile}.html")
  exit(0)
end

puts src.to_html

# this ain't workin' so hot
# output's incomplete 
#puts Nokogiri::XML(src.to_html, &:noblanks).to_xhtml(indent: 4)

#src.blocks.each do |b|
#  puts b.to_html
#end

=begin

roff = Troff.new("gl2","w2.5")
roff.parse(src.lines).each { |l| puts l.inspect }

puts "TITLE: #{roff.title} SECTION: #{roff.section}"
puts


#puts source.format 
puts source.header#.dump
puts source.title << " " << source.section
=end
