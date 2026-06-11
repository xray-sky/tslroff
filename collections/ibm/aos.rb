# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 10/07/19.
# Copyright 2019 Typewritten Software. All rights reserved.
#
#
# IBM AOS Platform Overrides
#

require_relative 'modules/aos/troff'
require_relative 'modules/aos_4.3'

module AOS

  def self.name_for_section(sec)
    case sec.downcase
    when '1'  then "<strong>#{sec}.</strong> Commands"
    when '1c' then "<strong>#{sec}.</strong> Communications Commands"
    when '1g' then "<strong>#{sec}.</strong> Graphics Commands"
    when '2'  then "<strong>#{sec}.</strong> System Calls"
    when '3'  then "<strong>#{sec}.</strong> C Library"
    when '3c' then "<strong>#{sec}.</strong> Compatibility Routines"
    when '3f' then "<strong>#{sec}.</strong> FORTRAN Library"
    when '3g' then "<strong>#{sec}.</strong> Graphics Suboutines"
    when '3m' then "<strong>#{sec}.</strong> Math Library"
    when '3n' then "<strong>#{sec}.</strong> Network Support Library"
    when '3r' then "<strong>#{sec}.</strong> RPC Library"
    when '3s' then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3x' then "<strong>#{sec}.</strong> Miscellaneous Functions"
    when '4'  then "<strong>#{sec}.</strong> Special Files and Hardware Support"
    when '4f' then "<strong>#{sec}.</strong> Network Protocol Families"
    when '4n' then "<strong>#{sec}.</strong> Network Facilities"
    when '4p' then "<strong>#{sec}.</strong> Network Protocols"
    when '5'  then "<strong>#{sec}.</strong> File Formats"
    when '6'  then "<strong>#{sec}.</strong> Games"
    when '7'  then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '8'  then "<strong>#{sec}.</strong> Maintenance Commands"
    when '8c' then "<strong>#{sec}.</strong> Network Services"
    when '8r' then "<strong>#{sec}.</strong> Hardware Maintenance Commands"
    when '8v' then "<strong>#{sec}.</strong> VAX Compatibility Commands"
    else "Section #{sec}"
    end
  end

end
