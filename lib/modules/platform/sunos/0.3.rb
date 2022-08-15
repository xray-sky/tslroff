# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 08/09/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# SunOS 0.3 Platform Overrides
#
# TODO
#   tbl(1) has postprocessed tbl (raw troff, not tbl source)
#          - can we make this render? or will we have to resort to a rewrite
#   access(3f) has postprocessed tbl, maybe other problems
#
#
# getgrent.3 [33]: .so can't read /usr/include/grp.h
# getpwent.3 [32]: .so can't read /usr/include/pwd.h
# time.3 [37]: .so can't read /usr/include/sys/timeb.h
# times.3 [25]: .so can't read /usr/include/sys/times.h
# acct.5 [16]: .so can't read /usr/include/sys/acct.h
# ar.5 [24]: .so can't read /usr/include/ar.h
# utmp.5 [15]: .so can't read /usr/include/utmp.h
#
#

module SunOS_0_3

  def self.extended(k)
    k.define_singleton_method(:req_LP, k.method(:req_PP)) if k.methods.include?(:req_PP)
    case k.instance_variable_get '@input_filename'
    when 'index.3f'
      k.instance_variable_set '@manual_entry', '_index'
    when 'fs.h', 'inode.h'
      raise ManualIsBlacklisted, 'apparently detritus'
    end
  end

  def init_ds
    super
    @state[:named_string].merge!({
      ']W' => 'Sun System Release 0.3'
    })
  end

  # REVIEW
  # this is used seemingly to prevent processing the next line
  # as a request. but, it's not in tmac.an or the DWB manual.
  def req_li(*args)
    parse("\\&" + next_line)
  end

  def req_TH(*args)
    heading = "#{args[0]}\\|(\\|#{args[1]}\\|)"
    req_ds ']D', case args[1]
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

    unescape("\\*(]W", output: @state[:footer])
    if args[2]
      req_ds ']L', args[2]
      unescape '\\0\\0\\(em\\0\\0\\*(]L', output: @state[:footer]
    end

    heading << '\\0\\0\\(em\\0\\0\\*(]D'
    super(*args, heading: heading)
  end

end


