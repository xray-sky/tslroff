# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/17/26.
# Copyright 2026 Typewritten Software. All rights reserved.
#
# BSDI BSD/386 Overrides
#

require_relative 'modules/bsd386/nroff'

module BSD386

  def self.name_for_section(sec)
    case sec.downcase
    when '1'    then "<strong>#{sec}.</strong> Commands"
    when '1c'   then "<strong>#{sec}.</strong> Communications Commands"
    when '1l'   then "<strong>#{sec}.</strong> Local Commands"
    when '2'    then "<strong>#{sec}.</strong> System Calls"
    when '3'    then "<strong>#{sec}.</strong> Subroutines and Libraries"
    when '3m'   then "<strong>#{sec}.</strong> Math Library"
    when '3x11' then "<strong>#{sec}.</strong> X11 Library"
    when '3xt'  then "<strong>#{sec}.</strong> X Toolkit"
    when '4'    then "<strong>#{sec}.</strong> Special Files"
    when '5'    then "<strong>#{sec}.</strong> File Formats"
    when '6'    then "<strong>#{sec}.</strong> Games"
    when '7'    then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '8'    then "<strong>#{sec}.</strong> Maintenance Commands"
    when '8c'   then "<strong>#{sec}.</strong> Communications Maintenance Commands"
    when '9'    then "<strong>#{sec}.</strong> Kernel Facilities"
    when 'l'    then "<strong>#{sec}.</strong> Local Commands"
    else "Section #{sec}"
    end
  end

end
