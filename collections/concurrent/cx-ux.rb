# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# Concurrent CX/UX Platform Overrides
#

require_relative 'modules/cx-ux/nroff'
require_relative 'modules/cx-ux/troff'
require_relative 'modules/cx-ux_6.20'

module CX_UX

  def self.name_for_section(sec)
    case sec.downcase
    when '1'   then "<strong>#{sec}.</strong> Commands"
    when '1c'  then "<strong>#{sec}.</strong> Communications Commands"
    when '1g'  then "<strong>#{sec}.</strong> Graphics Commands"
    when '1m'  then "<strong>#{sec}.</strong> Maintenance Commands"
    when '2'   then "<strong>#{sec}.</strong> System Calls"
    when '2p4' then "<strong>#{sec}.</strong> POSIX System Calls"
    when '3'   then "<strong>#{sec}.</strong> Subroutines and Libraries"
    when '3c'  then "<strong>#{sec}.</strong> C Library"
    when '3f'  then "<strong>#{sec}.</strong> FORTRAN Library"
    when '3m'  then "<strong>#{sec}.</strong> Math Library"
    when '3n'  then "<strong>#{sec}.</strong> Network Support Library"
    when '3p4' then "<strong>#{sec}.</strong> POSIX Compatibility Routines"
    when '3r'  then "<strong>#{sec}.</strong> RPC Library"
    when '3s'  then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3x'  then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '4'   then "<strong>#{sec}.</strong> File Formats"
    when '4c'  then "<strong>#{sec}.</strong> Network File Formats"
    when '4f'  then "<strong>#{sec}.</strong> Network Protocol Families"
    when '4n'  then "<strong>#{sec}.</strong> Network Facilities"
    when '4p'  then "<strong>#{sec}.</strong> Network Protocols"
    when '5'   then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '6'   then "<strong>#{sec}.</strong> Games"
    when '7'   then "<strong>#{sec}.</strong> Special Files"
    when '7c'  then "<strong>#{sec}.</strong> Communications Special Files"
    when '8'   then "<strong>#{sec}.</strong> Maintenance Procedures"
    else "Section #{sec}"
    end
  end

end
