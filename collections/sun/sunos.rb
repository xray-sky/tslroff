# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/10/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# SunOS Platform Overrides
#

require_relative 'modules/sunos/nroff'
require_relative 'modules/sunos/troff'
require_relative 'modules/sunos_0.3'
require_relative 'modules/sunos_0.4'
require_relative 'modules/sunos_1.0'
require_relative 'modules/sunos_1.1'
require_relative 'modules/sunos_1.4u'
require_relative 'modules/sunos_2.0'
require_relative 'modules/sunos_2.2u'
require_relative 'modules/sunos_2.3u'
require_relative 'modules/sunos_3.0'
require_relative 'modules/sunos_3.2'
require_relative 'modules/sunos_3.4'
require_relative 'modules/sunos_3.5'
require_relative 'modules/sunos_4.0'
require_relative 'modules/sunos_4.1'
require_relative 'modules/sunos_5.1'
require_relative 'modules/sunos_5.2'
require_relative 'modules/sunos_5.3'
require_relative 'modules/sunos_5.4'
require_relative 'modules/sunos_5.5'
require_relative 'modules/sunos_5.6'
require_relative 'modules/sunos_5.10'

module SunOS

  def self.name_for_section(sec)
    case sec.downcase
    when '1'   then "<strong>#{sec}.</strong> Commands"
    when '1c'  then "<strong>#{sec}.</strong> Communications Commands"
    when '1g'  then "<strong>#{sec}.</strong> Graphics Commands"
    when '1l'  then "<strong>#{sec}.</strong> Commands"
    when '1v'  then "<strong>#{sec}.</strong> System V Commands"
    when '2'   then "<strong>#{sec}.</strong> System Calls"
    when '2v'  then "<strong>#{sec}.</strong> System V Calls"
    when '3'   then "<strong>#{sec}.</strong> C Library"
    when '3c'  then "<strong>#{sec}.</strong> Compatibility Routines"
    when '3f'  then "<strong>#{sec}.</strong> FORTRAN Library"
    when '3j'  then "<strong>#{sec}.</strong> Job Control Facility"
    when '3k'  then "<strong>#{sec}.</strong> Kernel VM Library Funtcions"
    when '3l'  then "<strong>#{sec}.</strong> Lightweight Processes Library"
    when '3m'  then "<strong>#{sec}.</strong> Math Library"
    when '3n'  then "<strong>#{sec}.</strong> Network Support Library"
    when '3r'  then "<strong>#{sec}.</strong> RPC Library"
    when '3s'  then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3v'  then "<strong>#{sec}.</strong> System V Compatibility Routines"
    when '3w'  then "<strong>#{sec}.</strong> OLIT Library"
    when '3x'  then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '3xt' then "<strong>#{sec}.</strong> X Toolkit"
    when '4'   then "<strong>#{sec}.</strong> Device Drivers"
    when '4f'  then "<strong>#{sec}.</strong> Network Protocol Families"
    when '4i'  then "<strong>#{sec}.</strong> IP Special Files and Protocols"
    when '4m'  then "<strong>#{sec}.</strong> STREAMS Module Files"
    when '4n'  then "<strong>#{sec}.</strong> Network Facilities"
    when '4p'  then "<strong>#{sec}.</strong> Network Protocols"
    when '4s'  then "<strong>#{sec}.</strong> Sun-specific Device Special Files"
    when '5'   then "<strong>#{sec}.</strong> File Formats"
    when '5v'  then "<strong>#{sec}.</strong> System V File Formats"
    when '6'   then "<strong>#{sec}.</strong> Games and Demos"
    when '7'   then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '7v'  then "<strong>#{sec}.</strong> System V Miscellaneous Facilities"
    when '8'   then "<strong>#{sec}.</strong> Maintenance Commands"
    when '8c'  then "<strong>#{sec}.</strong> Network Services"
    when '8s'  then "<strong>#{sec}.</strong> Sun-specific Maintenance Commands"
    when '8v'  then "<strong>#{sec}.</strong> System V Maintenance Commands"
    when 'l'   then "<strong>#{sec}.</strong> Local Commands"
    else "Section #{sec}"
    end
  end

  def self.name_for_section_sunos5(sec)
    case sec.downcase
    when '1'    then "<strong>#{sec}.</strong> Commands"
    when '1b'   then "<strong>#{sec}.</strong> SunOS/BSD Compatibility Commands"
    when '1c'   then "<strong>#{sec}.</strong> Communications Commands"
    when '1f'   then "<strong>#{sec}.</strong> FMLI Commands"
    when '1m'   then "<strong>#{sec}.</strong> Maintenance Commands"
    when '1s'   then "<strong>#{sec}.</strong> SunOS-specific Commands"
    when '1x'   then "<strong>#{sec}.</strong> X11 Commands"
    when '2'    then "<strong>#{sec}.</strong> System Calls"
    when '3'    then "<strong>#{sec}.</strong> Functions and Libraries"
    when '3b'   then "<strong>#{sec}.</strong> SunOS/BSD Compatibility Routines"
    when '3c'   then "<strong>#{sec}.</strong> C Library"
    when '3e'   then "<strong>#{sec}.</strong> ELF Library"
    when '3g'   then "<strong>#{sec}.</strong> General Purpose Library"
    when '3i'   then "<strong>#{sec}.</strong> International Library"
    when '3k'   then "<strong>#{sec}.</strong> Kernel VM Library Functions"
    when '3m'   then "<strong>#{sec}.</strong> Math Library"
    when '3n'   then "<strong>#{sec}.</strong> Network Support Library"
    when '3r'   then "<strong>#{sec}.</strong> RPC Library"
    when '3s'   then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3t'   then "<strong>#{sec}.</strong> Threads Library"
    when '3w'   then "<strong>#{sec}.</strong> OLIT Library"
    when '3x'   then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '3x11' then "<strong>#{sec}.</strong> X11 Library"
    when '3xau' then "<strong>#{sec}.</strong> Xauth Library"
    when '3xc'  then "<strong>#{sec}.</strong> X/Open Curses Library"
    when '3xt'  then "<strong>#{sec}.</strong> X Toolkit"
    when '4'    then "<strong>#{sec}.</strong> File Formats"
    when '4b'   then "<strong>#{sec}.</strong> SunOS/BSD File Formats"
    when '5'    then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '6'    then "<strong>#{sec}.</strong> Games and Demos"
    when '7'    then "<strong>#{sec}.</strong> Special Files"
    when '7d'   then "<strong>#{sec}.</strong> Device Special Files"
    when '7fs'  then "<strong>#{sec}.</strong> File Systems Programming Interface"
    when '7i'   then "<strong>#{sec}.</strong> Device Ioctls"
    when '7m'   then "<strong>#{sec}.</strong> STREAMS Module Files"
    when '7p'   then "<strong>#{sec}.</strong> Network Protocols"
    when '8'    then "<strong>#{sec}.</strong> Maintenance Procedures"
    when '9'    then "<strong>#{sec}.</strong> DDI/DKI Interfaces"
    when '9e'   then "<strong>#{sec}.</strong> DDI/DKI Entry Points"
    when '9f'   then "<strong>#{sec}.</strong> DDI/DKI Kernel Functions"
    when '9s'   then "<strong>#{sec}.</strong> DDI/DKI Data Structures"
    else "Section #{sec}"
    end
  end

end

# all literally identical
SunOS::V4_1_1 = SunOS::V4_1
SunOS::V4_1_2 = SunOS::V4_1
SunOS::V4_1_3 = SunOS::V4_1
SunOS::V4_1_3B = SunOS::V4_1
SunOS::V4_1_3_U1 = SunOS::V4_1
SunOS::V4_1_4 = SunOS::V4_1

# module alias
SunOS::V5_5_1 = SunOS::V5_5
