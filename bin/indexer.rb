#! /usr/bin/env ruby
#
# indexer.rb
#
# Created by R. Stricklin <bear@typewritten.org> on 06/27/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
# generate indices of unix manual pages (provide some ux;
# solve the problem of manual entries for programs called 'index')
#
# TODO some method for naming the various sections (man3g, man5, man7, etc.) where they vary by system
# TODO ?? for broken pages (with no NAME section ) like at_nvelkup(1) [A/UX 0.7]
#  - probably need support from tslroff to create some kind of selector to ref here
# TODO troff not going great either due to constructs like enscript(1) [A/UX 0.7]
#  - or is this due to my having temporarily dorked up escape processing
# TODO what to do about file entries that don't match 'NAME' section
#    "machid.html"=>
#    "m68k, pdp11, u3b, u3b5, vax - provide truth value about processor type",
#  - also group them all on one line?
#  - maybe do the hash keyed on description, and an array of filenames as value?
#  - strip names, just file -> description?
# TODO sort 'intro' to top of list?
#  - try to get section description from 'intro'?
#

require 'nokogiri'
require 'pp'

def get_summary(file)
  doc = Nokogiri::HTML(File.new(file))
  get_summary_troff_man(doc) || get_summary_nroff_man(doc) || get_summary_aegis_help(doc)
end

def get_summary_troff_man(doc)
  doc.xpath("//h2[text()='NAME']")&.first&.next_element&.text&.gsub(/\n */m, ' ')&.strip&.rstrip
end

def get_summary_nroff_man(doc)
  # TODO hyphens at EOL are a problem, because we have both 'single-\nprecision' and 'sub-\ntract'
  #       for now, keep the hyphen but delete \n (instead of subbing ' ')
  doc.css('pre.n')&.first&.text&.match(/\n(?<indent> *)NAME\n(?<summary>.+?)\n+\k<indent>[A-Z]/m)&.[](:summary)&.gsub(/-\n */m, '-')&.gsub(/\n */m, ' ')&.strip # REVIEW watch heading indents
end

def get_summary_aegis_help(doc)
  doc.css('pre.n')&.first&.text&.split("\n")&.[](1) # fixed second line - assumes nroff_man already tried & failed
end

ARGV.each do |dir|
  filemap = Hash.new { |k,v| k[v] = Hash.new(&k.default_proc) }
  # map all the html files
  Dir.glob('**/*.html', base: dir) do |file|
  #Dir.glob('**/ali*.html', base: dir) do |file|
    hier = File.dirname(file).split('/')
    name = File.basename(file)
    summary = { name => get_summary("#{dir}/#{file}") }
    filemap.dig(*hier).merge! summary
  end
  pp filemap
end
