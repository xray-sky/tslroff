# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Acorn RISCix Platform Overrides
#

require_relative 'modules/riscix/troff'
require_relative 'modules/riscix_1.2'

module RISCiX

  def self.name_for_section(sec)
    case sec.downcase
    when '1'     then "<strong>#{sec}.</strong> Commands"
    when '1c'    then "<strong>#{sec}.</strong> Communications Commands"
    when '1g'    then "<strong>#{sec}.</strong> Graphics Commands"
    when '1v'    then "<strong>#{sec}.</strong> System V Commands"
    when '1x'    then "<strong>#{sec}.</strong> X11 Commands"
    when '2'     then "<strong>#{sec}.</strong> System Calls"
    when '3'     then "<strong>#{sec}.</strong> C Library"
    when '3c'    then "<strong>#{sec}.</strong> Compatibility Routines"
    when '3f'    then "<strong>#{sec}.</strong> FORTRAN Library"
    when '3m'    then "<strong>#{sec}.</strong> Math Library"
    when '3n'    then "<strong>#{sec}.</strong> Network Support Library"
    when '3r'    then "<strong>#{sec}.</strong> RPC Library and Protocols"
    when '3s'    then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3x'    then "<strong>#{sec}.</strong> Miscellaneous Routines"
    when '3x11'  then "<strong>#{sec}.</strong> X11 Library"
    when '3xext' then "<strong>#{sec}.</strong> X Extensions"
    when '3xm'   then "<strong>#{sec}.</strong> Motif Library"
    when '3xt'   then "<strong>#{sec}.</strong> X Toolkit"
    when '4'     then "<strong>#{sec}.</strong> Special Files and Hardware Support"
    when '4f'    then "<strong>#{sec}.</strong> Network Protocol Families"
    when '4n'    then "<strong>#{sec}.</strong> Network Facilities"
    when '4p'    then "<strong>#{sec}.</strong> Network Protocols"
    when '5'     then "<strong>#{sec}.</strong> File Formats"
    when '6'     then "<strong>#{sec}.</strong> Games"
    when '7'     then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '8'     then "<strong>#{sec}.</strong> Maintenance Commands"
    when '8c'    then "<strong>#{sec}.</strong> Network Services"
    when '8v'    then "<strong>#{sec}.</strong> Maintenance Procedures"
    else "Section #{sec}"
    end
  end

end
