# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/23/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# Univel/Novell UnixWare Platform Overrides
#
# Odd pages margin is 7 spaces; even pages have 6
# Some entries include _bsd in the filename (sum.1, sum_bsd.1)
#   - we'll handle that with man1/ and man1bsd/
#   - also _xnx plus _bfs, _cdfs, _nucfs, etc.
#
# TODO: some pages use 'SEE ALSO' instead of 'REFERENCES'
#   - $ find man/ -type f -print | xargs grep SEE\ ALSO | wc -l
#           59
#

module UnixWare
  class Nroff < Nroff
    def initialize(source)
      if source.file =~ /_to_.+\.3/
        @manual_section = '3BSD'
        @output_directory = 'man3bsd'
        ''
      end

      @manual_entry ||= source.file.sub(/(?:_bsd|_.+fs|_s5|_xnx)?\.(?:[\dZz]\S?)$/, '')
      @heading_detection ||= %r(^\s{6,7}(?<section>[A-Z][A-Za-z\s]+)$)
      @title_detection ||= %r{^       (?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))}
      @related_info_heading ||= 'REFERENCES'
      super source
    end
  end
end
