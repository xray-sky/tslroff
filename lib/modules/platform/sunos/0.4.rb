# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/09/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# SunOS 0.4 Platform Overrides
#

class SunOS::V0_4
  class Troff < SunOS::Troff

    MANUAL_SECTION_NAMES = {
      '1'  => "User's Manual \\(em Commands",
      '1C' => "User's Manual \\(em Communications",
      '1G' => "User's Manual \\(em Graphics",
      '2'  => "System Interface Manual \\(em System Calls",
      '3'  => "System Interface Manual \\(em Subroutines",
      '3F' => "System Interface Manual \\(em Fortran Interfaces",
      '3J' => "System Interface Manual \\(em Jobs Library",
      '3M' => "System Interface Manual \\(em Mathematical Functions",
      '3N' => "System Interface Manual \\(em Network Interfaces",
      '3S' => "System Interface Manual \\(em Standard I/O Library",
      '3X' => "System Interface Manual \\(em Miscellaneous",
      '4'  => "System Manager's Manual \\(em Special Files",
      '4I' => "System Manager's Manual \\(em Special Files",
      '4N' => "System Manager's Manual \\(em Special Files",
      '4P' => "System Manager's Manual \\(em Special Files",
      '4S' => "System Manager's Manual \\(em Special Files",
      '4V' => "System Manager's Manual \\(em Special Files",
      '5'  => "System Interface Manual \\(em File Formats",
      '6'  => "User's Manual \\(em Games and Demos",
      '7'  => "User's Manual \\(em Tables",
      '8'  => "System Manager's Manual \\(em Maintenance Commands",
      '8C' => "System Manager's Manual \\(em Communications"
    }

    MANUAL_SECTION_NAMES.default = 'UNKNOWN SECTION OF THE MANUAL'

    def init_ds
      super
      @named_strings.merge!(
        {
          ']W' => 'Sun System Release 0.3' # not a mistake
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
      ds "]L #{args[2]}"
      ds "]D #{MANUAL_SECTION_NAMES[args[1]]}"

      heading = "#{args[0]}\\|(\\|#{args[1]}\\|)\\0\\0\\(em\\0\\0\\*(]D"
      @named_strings[:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @named_strings[']L'].empty?

      super(*args, heading: heading)
    end

  end
end
