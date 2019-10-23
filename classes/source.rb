# Created by R. Stricklin <bear@typewritten.org> on 05/10/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# Source file class
# Just a container to hold input lines & determine where to hand off
#

require 'classes/file/magic.rb'

class Source
  attr_reader :lines, :magic, :filename

  def initialize(file)
    @filename = file
    begin
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
      else
        @lines = IO.readlines(file)
      end
    rescue
      warn $!
      exit(1)
    end

    @magic = case @lines[0]
             when /^<.+?>/   then 'HTML'   # html, probably
             when /^[\.\']./ then 'Troff'  # troff source, probably
             else                 'Nroff'  # plain text with or without carriage control
             end
  end
end
