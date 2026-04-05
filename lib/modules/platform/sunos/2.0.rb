# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/09/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# SunOS 2.0 Platform Overrides
#

module SunOS
  module V2_0
    class Source < Source
      def initialize(file, **kwargs, &block)
        case File.basename file
        when 'skyversion.8' then kwargs[:magic] = 'Troff'
        end
        super(file, **kwargs, &block)
      end
    end

    class Troff < Troff
      def init_ds
        super
        @named_strings.merge!(
          {
            ']W' => 'Sun Release 2.0'
          }
        )
      end

      # REVIEW
      # this is used seemingly to prevent processing the next line
      # as a request. but, it's not in tmac.an or the DWB manual.
      # still used in 2.0, but only for binmail(1)
      def li(*_args)
        parse("\\&" + next_line)
      end

      def TH(*args)
        ds "]L Last change: #{args[2]}"
        ds "]D #{MANUAL_SECTION_NAMES[args[1]]}"

        heading = "#{args[0]}\\|(\\|#{args[1]}\\|)\\0\\0\\(em\\0\\0\\*(]D"
        @named_strings[:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @named_strings[']L'].empty?

        super(*args, heading: heading)
      end

    end

    MANUAL_SECTION_NAMES = {
      '1'  => 'USER COMMANDS',
      '1C' => 'USER COMMANDS',
      '1G' => 'USER COMMANDS',
      '1S' => 'SUN-SPECIFIC USER COMMANDS',
      '1V' => 'VAX-SPECIFIC USER COMMANDS',
      '2'  => 'SYSTEM CALLS',
      '3'  => 'SUBROUTINES',
      '3C' => 'COMPATIBILITY ROUTINES',
      '3F' => 'FORTRAN LIBRARY ROUTINES',
      '3M' => 'MATHEMATICAL FUNCTIONS',
      '3N' => 'NETWORK FUNCTIONS',
      '3S' => 'STANDARD I/O LIBRARY',
      '3X' => 'MISCELLANEOUS FUNCTIONS',
      '4'  => 'SPECIAL FILES',
      '4F' => 'SPECIAL FILES',
      '4I' => 'SPECIAL FILES',
      '4N' => 'SPECIAL FILES',
      '4P' => 'SPECIAL FILES',
      '4S' => 'SPECIAL FILES',
      '4V' => 'SPECIAL FILES',
      '5'  => 'FILE FORMATS',
      '6'  => 'GAMES AND DEMOS',
      '7'  => 'TABLES',
      '8'  => 'MAINTENANCE COMMANDS',
      '8C' => 'MAINTENANCE COMMANDS',
      '8S' => 'MAINTENANCE COMMANDS'
    }

    MANUAL_SECTION_NAMES.default = 'UNKNOWN SECTION OF THE MANUAL'
    MANUAL_SECTION_NAMES.freeze
  end
end
