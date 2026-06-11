# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Solbourne OS/MP Platform Overrides
#

require_relative 'modules/os-mp/nroff'
require_relative 'modules/os-mp/troff'

module OS_MP

  def self.name_for_section(sec)
    case sec.downcase
    when '1'    then "<strong>#{sec}.</strong> Commands"
    when '1c'   then "<strong>#{sec}.</strong> Communications Commands"
    when '1g'   then "<strong>#{sec}.</strong> Graphics Commands"
    when '1l'   then "<strong>#{sec}.</strong> Commands"
    when '1m'   then "<strong>#{sec}.</strong> System V Maintenance Commands"
    when '1v'   then "<strong>#{sec}.</strong> System V Commands"
    when '2'    then "<strong>#{sec}.</strong> System Calls"
    when '2v'   then "<strong>#{sec}.</strong> System V Calls"
    when '3'    then "<strong>#{sec}.</strong> C Library"
    when '3c'   then "<strong>#{sec}.</strong> Compatibility Routines"
    when '3f'   then "<strong>#{sec}.</strong> FORTRAN Library"
    when '3k'   then "<strong>#{sec}.</strong> Kernel VM Library Functions"
    when '3l'   then "<strong>#{sec}.</strong> Lightweight Processes Library"
    when '3m'   then "<strong>#{sec}.</strong> Math Library"
    when '3n'   then "<strong>#{sec}.</strong> Network Support Library"
    when '3r'   then "<strong>#{sec}.</strong> RPC Library"
    when '3s'   then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3v'   then "<strong>#{sec}.</strong> POSIX/System V Compatibility Routines"
    when '3w'   then "<strong>#{sec}.</strong> OLIT Library"
    when '3x'   then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '3x11' then "<strong>#{sec}.</strong> X11 Library"
    when '3xt'  then "<strong>#{sec}.</strong> X Toolkit"
    when '4'    then "<strong>#{sec}.</strong> Device Special Files"
    when '4f'   then "<strong>#{sec}.</strong> Network Protocol Families"
    when '4m'   then "<strong>#{sec}.</strong> STREAMS Module Files"
    when '4n'   then "<strong>#{sec}.</strong> Network Facilities"
    when '4p'   then "<strong>#{sec}.</strong> Network Protocols"
    when '4s'   then "<strong>#{sec}.</strong> Solbourne-specific Device Special Files"
    when '5'    then "<strong>#{sec}.</strong> File Formats"
    when '6'    then "<strong>#{sec}.</strong> Games and Demos"
    when '7'    then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '7v'   then "<strong>#{sec}.</strong> System V Miscellaneous Facilities"
    when '8'    then "<strong>#{sec}.</strong> Maintenance Commands"
    when '8c'   then "<strong>#{sec}.</strong> Network Services"
    when '8s'   then "<strong>#{sec}.</strong> Solbourne-specific Maintenance Commands"
    when '8v'   then "<strong>#{sec}.</strong> POSIX/System V Maintenance Commands"
    when 'l'    then "<strong>#{sec}.</strong> Local Commands"
    else "Section #{sec}"
    end
  end

end
