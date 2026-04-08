# frozen_string_literal: true
#
# Created by R. Stricklin <bear@typewritten.org> on 05/10/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# Source file class
#  - interface providing lines from file (or block), decompressing if necessary
#  - interpret logical format of file contents
#  - rewrite file contents in memory, if necessary to address defects in the source material
#

require_relative '../../ext/file/magic'

class Source
  attr_reader :dir, :file, :path, :magic, :iter, :line_number #, :lines

  def initialize(file, magic: nil, encoding: nil, record_separator: $/, &block)
    if file
      @path = file
      @file = File.basename(file)
      @dir = File.dirname(file)
      @target = File.readlink(file) if File.symlink?(file)
    end

    @lines = if block_given?
               yield(file, record_separator: record_separator, encoding: encoding)
             else
               IO.readlines(stream_decompress, record_separator, external_encoding: encoding, internal_encoding: Encoding::UTF_8)
             end

    @line_number = 0
    @iter = @lines.each

    @magic = magic || infer_magic
  end

  def index(&block)
    @lines.index &block
  end

  def link?
    !@target.nil?
  end

  def next_line
    @line_number += 1
    @iter.next
  end

  ###
  ### in-place source edit
  ###

  # replaces re with repl on numbered line only, (uses gsub if global: true)
  def patch_line(l, re, repl, global: false)
    # 0-indexed array => 1-indexed lines
    @lines[l - 1].send((global ? :gsub! : :sub!), re, repl)
  end

  # replaces re with repl on each numbered line, (uses gsub if global: true)
  def patch_lines(lines, re, repl, global: false)
    lines.each { |l| patch_line l, re, repl, global: global }
  end

  #replaces re with repl, full file (uses gsub if global: true)
  def patch(re, repl, global: false)
    @lines.each { |l| l.send((global ? :gsub! : :sub!), re, repl) }
  end

  private

  # decompress/unpack
  #
  # TODO
  #
  # this might be useful later for dealing productively with tar files.
  # https://gist.github.com/sinisterchipmunk/1335041
  #
  # also I need to re-enter in case of a gzipped tar file.
  # is this even worth doing?
  #
  # TODO need to re-enter in the case of the HP ANSI-C A.10.11-S700 manual,
  #      which is gzipped compressed data. (WHY.)
  #

  def stream_decompress
    case File.magic @path
    when 'tar'     then raise ArgumentError, "#{@path}: is tape archive (skipped)"
    # OS X 10.6 gzip does it all, even if zlib or OS X gzip won't.
    when 'lzh_sco' then %(|gzip_10.6 -dc "#{@path}")
    # OS X gzip does it all, even if zlib won't.
    when 'compress', 'gzip', 'oldpack', 'pack'
      %(|gzip -dc "#{@path}")
    else @path
    end
  end

  # try to guess what sort of text format we are dealing with
  # files containing only whitespace or null bytes are considered empty

  def infer_magic
    # use the first non-blank line - cc(1) [GL2-W2.5]
    case @lines.detect { |l| l.match?(/[^\0\s\n\r]/) }
    when nil         then raise ManualIsBlacklisted, "#{@filename}: empty file (skipped)" # there weren't any
    when /^\s*<.+?>/ then :HTML   # html, probably
    when /^[.']./    then :Troff  # troff source, probably
    else                  :Nroff  # plain text with or without carriage control
    end
  rescue ArgumentError => e # invalid byte sequence
    # give ourselves a chance to punt JUST IN CASE
    # - e.g. BeOS R3 PressInfo/aboutbe/pressreleases/97-08-04_adamation.html
    warn "#{@filename}: exception inferring text format: #{e.message}"
    :Unknown
  end

end
