# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/23/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# SCO OpenDesktop Platform Overrides
#

require_relative 'modules/opendesktop/manual'
require_relative 'modules/opendesktop_1.0.0y'
require_relative 'modules/opendesktop_1.1.0'
require_relative 'modules/opendesktop_1.1.1g'

module OpenDesktop

  def self.name_for_section(sec)
    case sec.downcase
    when '1'    then "<strong>#{sec}.</strong> X11 Commands"
    when '1m'   then "<strong>#{sec}.</strong> Maintenance Commands" # VxVM
    when 'adm'  then "<strong>#{sec}.</strong> System Administration Commands"
    when 'admn' then "<strong>#{sec}.</strong> Network Administration Commands"
    when 'admp' then "<strong>#{sec}.</strong> Special Files and Protocols"
    when 'c'    then "<strong>#{sec}.</strong> Commands"
    when 'cmd'  then "<strong>#{sec}.</strong> DOS Commands"
    when 'cp'   then "<strong>#{sec}.</strong> Programming Commands"
    when 'ct'   then "<strong>#{sec}.</strong> Text Processing Commands"
    when 'dos'  then "<strong>#{sec}.</strong> DOS Commands"
    when 'f'    then "<strong>#{sec}.</strong> File Formats"
    when 'hw'   then "<strong>#{sec}.</strong> Hardware-dependent Features and Files"
    when 'lm'   then "<strong>#{sec}.</strong> LAN Manager Commands and Files"
    when 'm'    then "<strong>#{sec}.</strong> Miscellaneous Features and File Formats"
    when 'n'    then "<strong>#{sec}.</strong> ONC Operation and Maintenance Commands"
    when 'nadm' then "<strong>#{sec}.</strong> ONC Operation and Maintenance Commands" # ODT
    when 'nc'   then "<strong>#{sec}.</strong> ONC Commands"
    when 'nf'   then "<strong>#{sec}.</strong> ONC File Formats"
    when 'padm' then "<strong>#{sec}.</strong> IPX Operation and Maintenance Commands"
    when 'sff'  then "<strong>#{sec}.</strong> Network File Formats"
    when 'tc'   then "<strong>#{sec}.</strong> TCP/IP Commands"
    when 'x'    then "<strong>#{sec}.</strong> X11 Commands"
# SDS pages - TODO parse correctly!
    when 'k'    then "<strong>#{sec}.</strong> Kernel Routines"
    when 'ns'   then "<strong>#{sec}.</strong> Network Routines"
    when 'nsl'  then "<strong>#{sec}.</strong> Network Services Library"
    when 's'    then "<strong>#{sec}.</strong> System Services and Library Routines"
    when 'sco'  then "<strong>#{sec}.</strong> SystemV/386 specific Commands"
    when 'str'  then "<strong>#{sec}.</strong> STREAMS Library"
    when 'xm'   then "<strong>#{sec}.</strong> Motif Library"
    when 'xnx'  then "<strong>#{sec}.</strong> Xenix Compatibility Commands"
    when 'xs'   then "<strong>#{sec}.</strong> X11 Library"
    when 'xt'   then "<strong>#{sec}.</strong> X Toolkit"
    else "Section #{sec}"
    end
  end

end

# module alias
SCO_SysV386 = OpenDesktop
