# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/04/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# SunSoft Interactive UNIX v3.2r4.1 Platform Overrides
#
# TODO
# √ constantly shrinking \s? e.g. Xcpqag(1)
# √ explicit .ps 10 after .TE is "interfering" with our default size of 12 on \s-1::\s+1 e.g. Xwge(1)
#    -- should maybe put a nuclear strategy in }f or .SS/.SH or wherever, so :prev_ps doesn't drift
#   Xvga(1), Xv256(1) :: tbl missing cell borders on spanned "resolution" rows
#   ksh(1) :: wtf
#

module Interactive
  module V3_2r4_1
    class Source < Source
      def initialize(file, **kwargs, &block)
        case File.basename file
        when 'file' then raise ManualIsBlacklisted, 'is shell script'
        when 'i596.7'
          kwargs[:magic] = :Troff
          patch_line 1, /^/, '.\\"' # misidentified as nroff
        end
        super(file, **kwargs, &block)
      end
    end

    class Troff < Troff
      def initialize(source)
        case source.file
        when /intro\.nfs\.(\d)/ # easier to just override these than mess with the regex
          @manual_entry = 'intro.nfs'
          @manual_section = Regexp.last_match[1]
        end
        super(source)
      end

    end
  end
end
