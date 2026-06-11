# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 01/4/26.
# Copyright 2026 Typewritten Software. All rights reserved.
#
#
# SGI 4D1 UNIX & IRIX Platform Overrides
#

require_relative 'modules/irix/nroff'
require_relative 'modules/irix_6.5'

module IRIX

  def self.name_for_section(sec)
    case sec.downcase
    when '1'      then "<strong>#{sec}.</strong> Commands"
    when '1-sysv' then "<strong>#{sec}.</strong> System V Compatibility Commands"
    when '1c'     then "<strong>#{sec}.</strong> Communications Commands"
    when '1d'     then "<strong>#{sec}.</strong> Graphics Demos"
    when '1g'     then "<strong>#{sec}.</strong> Graphics Commands"
    when '1l'     then "<strong>#{sec}.</strong> Local Commands"
    when '1m'     then "<strong>#{sec}.</strong> Maintenance Commands"
    when '1pf'    then "<strong>#{sec}.</strong> IRIS Performer Commands"
    when '1v'     then "<strong>#{sec}.</strong> Video Commands"
    when '1x'     then "<strong>#{sec}.</strong> 4Dwm Commands"
    when '2'      then "<strong>#{sec}.</strong> System Calls"
    when '3'      then "<strong>#{sec}.</strong> Functions and Libraries"
    when '3b'     then "<strong>#{sec}.</strong> 4.3BSD Compatibility Routines"
    when '3c'     then "<strong>#{sec}.</strong> C Library"
    when '3dm'    then "<strong>#{sec}.</strong> Digital Media Libraries"
    when '3e'     then "<strong>#{sec}.</strong> ELF Library"
    when '3g'     then "<strong>#{sec}.</strong> IRIS Graphics Library"
    when '3l'     then "<strong>#{sec}.</strong> Sphere Library"
    when '3m'     then "<strong>#{sec}.</strong> Math Library"
    when '3n'     then "<strong>#{sec}.</strong> Network Support Library"
    when '3p'     then "<strong>#{sec}.</strong> Parallel Processing Interfaces"
    when '3pf'    then "<strong>#{sec}.</strong> IRIS Performer Library"
    when '3r'     then "<strong>#{sec}.</strong> RPC Library"
    when '3s'     then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3t'     then "<strong>#{sec}.</strong> Terminal Library"
    when '3w'     then "<strong>#{sec}.</strong> International Library"
    when '3x'     then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '3x11'   then "<strong>#{sec}.</strong> X11 Library"
    when '3xh'    then "<strong>#{sec}.</strong> X Toolkit Intrinsics Library"
    when '3xt'    then "<strong>#{sec}.</strong> X Toolkit"
    when '3y'     then "<strong>#{sec}.</strong> Yellow Pages Library"
    when '4'      then "<strong>#{sec}.</strong> File Formats"
    when '5'      then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '5x'     then "<strong>#{sec}.</strong> X11 File Formats"
    when '6'      then "<strong>#{sec}.</strong> Games and Demos"
    when '6d'     then "<strong>#{sec}.</strong> IRIS Games and Demos"
    when '6t'     then "<strong>#{sec}.</strong> IRIS GL Tutorials"
    when '7'      then "<strong>#{sec}.</strong> Special Files"
    when '7d'     then "<strong>#{sec}.</strong> Cray Text Formatting Macros"
    when '7f'     then "<strong>#{sec}.</strong> Network Protocol Families"
    when '7m'     then "<strong>#{sec}.</strong> SGI Specific Devices"
    when '7p'     then "<strong>#{sec}.</strong> Network Protocols"
    when '8'      then "<strong>#{sec}.</strong> Maintenance Procedures"
    when 'other'  then "Other"
    when 'sgi'    then "SGI"
    when 'sgi-resources' then "SGI Resources"
    else "Section #{sec}"
    end
  end

end

# module aliases
#4D1 = IRIX
