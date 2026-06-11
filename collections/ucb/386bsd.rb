# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 07/7/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# UC Berkeley 386BSD Platform Overrides
#

require_relative 'modules/386bsd/nroff'
require_relative 'modules/386bsd/troff'

module X386BSD

  def self.name_for_section(sec)
    case sec.downcase
    when '1'    then "<strong>#{sec}.</strong> Commands"
    when '1l'   then "<strong>#{sec}.</strong> Local Commands"
    when '2'    then "<strong>#{sec}.</strong> System Calls"
    when '3'    then "<strong>#{sec}.</strong> Subroutines and Libraries"
    when '3m'   then "<strong>#{sec}.</strong> Math Library"
    when '3x11' then "<strong>#{sec}.</strong> X11 Library"
    when '3xt'  then "<strong>#{sec}.</strong> X Toolkit"
    when '4'    then "<strong>#{sec}.</strong> Special Files"
    when '4/5'  then "<strong>#{sec}.</strong> XFree86 File Formats"
    when '5'    then "<strong>#{sec}.</strong> File Formats"
    when '5l'   then "<strong>#{sec}.</strong> Local File Formats"
    when '6'    then "<strong>#{sec}.</strong> Games"
    when '7'    then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '8'    then "<strong>#{sec}.</strong> Maintenance Commands"
    when '9'    then "<strong>#{sec}.</strong> Kernel Facilities"
    when 'gnu'  then "<strong>#{sec}.</strong> FSF Commands"
    else "Section #{sec}"
    end
  end

end
