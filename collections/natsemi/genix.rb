# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 10/05/26.
# Copyright 2026 Typewritten Software. All rights reserved.
#
#
# National Semiconductor GENIX Platform Overrides
#

require_relative 'modules/genix/nroff'

module GENIX

  def self.name_for_section(sec)
    case sec.downcase
    when '1'    then "<strong>#{sec}.</strong> Commands"
    when '1c'   then "<strong>#{sec}.</strong> Communications Commands"
    when '2'    then "<strong>#{sec}.</strong> System Calls"
    when '2j'   then "<strong>#{sec}.</strong> Job Control System Calls"
    when '2v'   then "<strong>#{sec}.</strong> Virtual Memory System Calls"
    when '3'    then "<strong>#{sec}.</strong> Subroutines and Libraries"
    when '3j'   then "<strong>#{sec}.</strong> Job Control Facilities"
    when '3m'   then "<strong>#{sec}.</strong> Math Library"
    when '3s'   then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3x'   then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '4'    then "<strong>#{sec}.</strong> Special Files"
    when '5'    then "<strong>#{sec}.</strong> File Formats"
    when '6'    then "<strong>#{sec}.</strong> Games"
    when '7'    then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '8'    then "<strong>#{sec}.</strong> Maintenance Commands"
    when 'i'    then "<strong>#{sec}.</strong>"
    else "Section #{sec}"
    end
  end

end
