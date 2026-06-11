# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/10/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Plan9 Platform Overrides
#

require_relative 'modules/plan9/troff'

module Plan9

  def self.name_for_section(sec)
    case sec.downcase
    when '1' then "<strong>#{'1'}.</strong> Commands"
    when '2' then "<strong>#{'2'}.</strong> System Calls and Libraries"
    when '3' then "<strong>#{'3'}.</strong> Kernel Devices"
    when '4' then "<strong>#{'4'}.</strong> File Services"
    when '5' then "<strong>#{'5'}.</strong> Plan 9 File Protocol"
    when '6' then "<strong>#{'6'}.</strong> File Formats"
    when '7' then "<strong>#{'7'}.</strong> Databases and Access Programs"
    when '8' then "<strong>#{'8'}.</strong> Maintenance Commands"
    else "Section #{sec}"
    end
  end

end
