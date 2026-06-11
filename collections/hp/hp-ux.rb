# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/16/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# HP-UX Platform Overrides
#

require_relative 'modules/hp-ux/troff'
require_relative 'modules/hp-ux_5.00'
require_relative 'modules/hp-ux_5.20'
require_relative 'modules/hp-ux_6.20'
require_relative 'modules/hp-ux_8.05'
require_relative 'modules/hp-ux_9.05'
require_relative 'modules/hp-ux_10.20'

module HPUX

  def self.name_for_section(sec)
    case sec.downcase
    when '0'     then "<strong>#{sec}.</strong> Preface"
    when '1'     then "<strong>#{sec}.</strong> Commands"
    when '1c++'  then "<strong>#{sec}.</strong> C++ Programming Commands"
    when '1g'    then "<strong>#{sec}.</strong> Graphics Commands"
    when '1m'    then "<strong>#{sec}.</strong> Maintenance Commands"
    when '1x'    then "<strong>#{sec}.</strong> Vue Commands"
    when '1x11'  then "<strong>#{sec}.</strong> X11 Commands"
    when '2'     then "<strong>#{sec}.</strong> System Calls"
    when '2v'    then "<strong>#{sec}.</strong> SVID System Calls"
    when '3'     then "<strong>#{sec}.</strong> Subroutines and Libraries"
    when '3c'    then "<strong>#{sec}.</strong> C Library"
    when '3c++'  then "<strong>#{sec}.</strong> C++ Libraries"
    when '3d'    then "<strong>#{sec}.</strong> Instrument Support Library" # HP-UX 5.00
    when '3f'    then "<strong>#{sec}.</strong> FORTRAN Library"
    when '3g'    then "<strong>#{sec}.</strong> Graphics Library"
    when '3i'    then "<strong>#{sec}.</strong> Instrument Support Library"
    when '3m'    then "<strong>#{sec}.</strong> Math Library"
    when '3n'    then "<strong>#{sec}.</strong> Network Support Libraries"
    when '3r'    then "<strong>#{sec}.</strong> RPC Functions"
    when '3s'    then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3w'    then "<strong>#{sec}.</strong> HP Windows Routines"
    when '3x'    then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '3x11'  then "<strong>#{sec}.</strong> X11 Library"
    when '4'     then "<strong>#{sec}.</strong> File Formats"
    when '4g'    then "<strong>#{sec}.</strong> Graphics File Formats"
    when '4x'    then "<strong>#{sec}.</strong> Vue File Formats"
    when '5'     then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '5x'    then "<strong>#{sec}.</strong> Vue Miscellaneous Facilities"
    when '6'     then "<strong>#{sec}.</strong> Networking Facilities"
    when '7'     then "<strong>#{sec}.</strong> Device Special Files"
    when '7f'    then "<strong>#{sec}.</strong> Protocol Families"
    when '7p'    then "<strong>#{sec}.</strong> Network Protocols"
    when '8'     then "<strong>#{sec}.</strong> Maintenance Procedures"
    when '8sdce' then "<strong>#{sec}.</strong> DCE Maintenance Procedures"
    when '9'     then "<strong>#{sec}.</strong> Glossary"
    else "Section #{sec}"
    end
  end

end

# all the same tmac.an
HPUX::V5_20::S300 = HPUX::V5_20
HPUX::V5_20::S500 = HPUX::V5_20
HPUX::V5_50 = HPUX::V5_20

# not strictly identical, though functionally so
HPUX::V6_00 = HPUX::V5_20

# all the same tmac.an
HPUX::V8_07 = HPUX::V9_05
HPUX::V9_00 = HPUX::V9_05
HPUX::V9_03 = HPUX::V9_05
HPUX::V9_04 = HPUX::V9_05
HPUX::V9_10 = HPUX::V9_05
