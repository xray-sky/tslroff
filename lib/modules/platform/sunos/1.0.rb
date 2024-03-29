# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/09/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# SunOS 1.0 Platform Overrides
#
# TODO
#   tbl(1) has postprocessed tbl (raw troff, not tbl source)
#          - can we make this render? or will we have to resort to a rewrite
#   lseek(2) has fixed (in inches) tabs that are too narrow for our font. maybe just try to fix the overlay, which shouldn't have happened in next_tab
# √ sail(6) has missing break at line 312 (Constitution v. Cyane) for some reason? (ah, no .nf)
#           .bp warns are ok (occur in context of regular Block.new)
# √ mailaddr(7) bad tabs -- expected with no .nf; lines beginning with tab don't count for breaking
#
#   acct.5 [17]: .so can't read /usr/include/sys/acct.h
#   types.5 [14]: .so can't read /usr/include/sys/types.h
#   utmp.5 [16]: .so can't read /usr/include/utmp.h
#

module SunOS_1_0

  def self.extended(k)
  end

  def init_ds
    super
    @state[:named_string].merge!(
      {
        ']W' => 'Sun System Release 1.0'
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
    req_ds "]L #{args[2]}"
    req_ds ']D ' + case args[1]
                   when '1'  then "User's Manual \\(em Commands"
                   when '1C' then "User's Manual \\(em Communications"
                   when '1G' then "User's Manual \\(em Graphics"
                   when '2'  then "System Interface Manual \\(em System Calls"
                   when '3'  then "System Interface Manual \\(em Subroutines"
                   when '3F' then "System Interface Manual \\(em Fortran Interfaces"
                   when '3J' then "System Interface Manual \\(em Jobs Library"
                   when '3M' then "System Interface Manual \\(em Mathematical Functions"
                   when '3N' then "System Interface Manual \\(em Network Interfaces"
                   when '3S' then "System Interface Manual \\(em Standard I/O Library"
                   when '3X' then "System Interface Manual \\(em Miscellaneous"
                   when '4'  then "System Manager's Manual \\(em Special Files"
                   when '4I' then "System Manager's Manual \\(em Special Files"
                   when '4N' then "System Manager's Manual \\(em Special Files"
                   when '4P' then "System Manager's Manual \\(em Special Files"
                   when '4S' then "System Manager's Manual \\(em Special Files"
                   when '4V' then "System Manager's Manual \\(em Special Files"
                   when '5'  then "System Interface Manual \\(em File Formats"
                   when '6'  then "User's Manual \\(em Games and Demos"
                   when '7'  then "User's Manual \\(em Tables"
                   when '8'  then "System Manager's Manual \\(em Maintenance Commands"
                   when '8C' then "System Manager's Manual \\(em Communications"
                   else 'UNKNOWN SECTION OF THE MANUAL'
                   end

    heading = "#{args[0]}\\|(\\|#{args[1]}\\|)\\0\\0\\(em\\0\\0\\*(]D"
    @state[:named_string][:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @state[:named_string][']L'].empty?

    super(*args, heading: heading)
  end

end


