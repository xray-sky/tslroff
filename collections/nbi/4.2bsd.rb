# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/05/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# ISI/NBI 4.2BSD Platform Overrides (tmac.an.new)
#

require_relative 'modules/4.2bsd/troff'

module NBI_4_2BSD

  def self.name_for_section(sec)
    case sec.downcase
    when '1'    then "<strong>#{sec}.</strong> Commands"
    when '1c'   then "<strong>#{sec}.</strong> Communications Commands"
    when '1g'   then "<strong>#{sec}.</strong> Graphics Commands"
    when '2'    then "<strong>#{sec}.</strong> System Calls"
    when '3'    then "<strong>#{sec}.</strong> Subroutines and Libraries"
    when '3c'   then "<strong>#{sec}.</strong> Compatibility Routines"
    when '3f'   then "<strong>#{sec}.</strong> FORTRAN Library"
    when '3m'   then "<strong>#{sec}.</strong> Math Library"
    when '3n'   then "<strong>#{sec}.</strong> Network Support Library"
    when '3s'   then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3x'   then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '4'    then "<strong>#{sec}.</strong> Special Files"
    when '4f'   then "<strong>#{sec}.</strong> Network Protocol Families"
    when '4i'   then "<strong>#{sec}.</strong> Integrated Solutions Specific Devices"
    when '4n'   then "<strong>#{sec}.</strong> Network Facilities"
    when '4p'   then "<strong>#{sec}.</strong> Network Protocols"
    when '5'    then "<strong>#{sec}.</strong> File Formats"
    when '6'    then "<strong>#{sec}.</strong> Games"
    when '7'    then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '8'    then "<strong>#{sec}.</strong> Maintenance Commands"
    else "Section #{sec}"
    end
  end

end
