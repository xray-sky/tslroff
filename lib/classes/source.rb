# Created by R. Stricklin <bear@typewritten.org> on 05/10/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# Source file class
# Just a container to hold input lines & determine where to hand off
#

require_relative 'file/magic.rb'

class Source
  attr_reader :lines, :magic, :filename

  def initialize(file)
    @filename = file
    case File.magic(file)
    when 'tar'
      raise ArgumentError, "Input file is tape archive: #{file}"
      # TODO:
      #
      # this might be useful later for dealing productively with tar files.
      # https://gist.github.com/sinisterchipmunk/1335041
      #
      # also I need to re-enter in case of a gzipped tar file.
      # is this even worth doing?
    when 'gz'
      @lines = IO.readlines("|gzip -dc #{file}")	# gzip does it all, even if zlib won't.
    when 'ogz'
      @lines = IO.readlines("|gzip_old -dc #{file}")	# 10.6 gzip does it all, even if zlib won't.
    else
      @lines = IO.readlines(file)
    end

    begin
      @magic = case @lines.find { |l| !l.match(/^\s+$/) } # use the first non-blank line - cc(1) [GL2-W2.5]
               when /^\s*<.+?>/ then :HTML   # html, probably
               when /^[\.\']./  then :Troff  # troff source, probably
               else                  :Nroff  # plain text with or without carriage control
               end
    rescue ArgumentError # invalid byte sequence
      # give ourselves a chance to punt JUST IN CASE
      # - e.g. BeOS R3 PressInfo/aboutbe/pressreleases/97-08-04_adamation.html
      @magic = :Unknown
    end
  end
end
