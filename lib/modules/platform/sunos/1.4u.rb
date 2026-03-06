# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/06/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# SunOS 1.4U Platform Overrides
#
#  doesn't seem to be an updated macro package in this update-only release
#  fake it with the 1.1 macro package, plus an updated \*(]W
#  REVIEW update this if we ever find the correct tmac.an
#
# TODO
#

class SunOS::V1_4U
  class Troff < ::SunOS::Troff

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

    def init_ds
      super
      @state[:named_string].merge!(
        {
        ']W' => 'Sun Release 1.4'
        }
      )
    end

    # REVIEW
    # this is used seemingly to prevent processing the next line
    # as a request. but, it's not in tmac.an or the DWB manual.
    def li(*_args)
      parse("\\&" + next_line)
    end

    define_method 'TH' do |*args|
      ds "]L Last change: #{args[2]}"
      ds "]D #{MANUAL_SECTION_NAMES[args[1]]}"

      heading = "#{args[0]}\\|(\\|#{args[1]}\\|)\\0\\0\\(em\\0\\0\\*(]D"
      @state[:named_string][:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @state[:named_string][']L'].empty?

      super(*args, heading: heading)
    end

  end
end
