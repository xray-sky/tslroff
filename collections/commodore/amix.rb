# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/16/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Amiga SVR4 Platform Overrides
#

require_relative 'modules/amix/nroff'
require_relative 'modules/amix/troff'
require_relative 'modules/amix_2.01'

module AMIX

  def self.name_for_section(sec)
    case sec.downcase
    when '1'    then "<strong>#{sec}.</strong> User Commands"
    when '1a'   then "<strong>#{sec}.</strong> Amiga-specific Commands"
    when '1c'   then "<strong>#{sec}.</strong> Communications Commands"
    when '1f'   then "<strong>#{sec}.</strong> FMLI Commands"
    when '1g'   then "<strong>#{sec}.</strong> Graphics Commands"
    when '1l'   then "<strong>#{sec}.</strong> Local Commands"
    when '1m'   then "<strong>#{sec}.</strong> Maintenance Commands"
    when '2'    then "<strong>#{sec}.</strong> System Calls"
    when '3'    then "<strong>#{sec}.</strong> C Library Functions"
    when '3a'   then "<strong>#{sec}.</strong> Amiga-specific Functions"
    when '3c'   then "<strong>#{sec}.</strong> Compatibility Functions"
    when '3e'   then "<strong>#{sec}.</strong> ELF Library"
    when '3g'   then "<strong>#{sec}.</strong> General Purpose Library"
    when '3m'   then "<strong>#{sec}.</strong> Mathematical Library"
    when '3n'   then "<strong>#{sec}.</strong> Network Support Library"
    when '3s'   then "<strong>#{sec}.</strong> Standard I/O Functions"
    when '3x'   then "<strong>#{sec}.</strong> Miscellaneous Library Functions"
    when '3x11' then "<strong>#{sec}.</strong> X11 Library"
    when '3xt'  then "<strong>#{sec}.</strong> X Toolkit"
    when '4'    then "<strong>#{sec}.</strong> Devices and Network Interfaces"
    when '5'    then "<strong>#{sec}.</strong> File Formats"
    when '5a'   then "<strong>#{sec}.</strong> Amiga-specific File Formats"
    when '6'    then "<strong>#{sec}.</strong> Games and Demos"
    when '7'    then "<strong>#{sec}.</strong> Public Files, Tables, and Troff Macros"
    when '7a'   then "<strong>#{sec}.</strong> Amiga-specific Devices"
    when '8'    then "<strong>#{sec}.</strong> Maintenance Commands"
    when '8c'   then "<strong>#{sec}.</strong> Communications Maintenance Commands"
    when '8l'   then "<strong>#{sec}.</strong> Local Maintenance Commands"
    when 'l'    then 'Local Commands'
    else "Section #{sec}"
    end
  end

end
