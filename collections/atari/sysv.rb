# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2014 Typewritten Software. All rights reserved.
#
# Atari SysV Platform Overrides
#

require_relative 'modules/sysv/nroff'
require_relative 'modules/sysv/troff'

module Atari_SysV

  def self.name_for_section(sec)
    case sec.downcase
    when '1'    then "<strong>#{sec}.</strong> Commands"
    when '1c'   then "<strong>#{sec}.</strong> Communications Commands"
    when '1f'   then "<strong>#{sec}.</strong> FMLI Utilities"
    when '1m'   then "<strong>#{sec}.</strong> Maintenance Commands"
    when '2'    then "<strong>#{sec}.</strong> System Calls"
    when '3'    then "<strong>#{sec}.</strong> C Library"
    when '3c'   then "<strong>#{sec}.</strong> C Library"
    when '3e'   then "<strong>#{sec}.</strong> ELF Library"
    when '3g'   then "<strong>#{sec}.</strong> General Purpose Library"
    when '3m'   then "<strong>#{sec}.</strong> Math Library"
    when '3s'   then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3x'   then "<strong>#{sec}.</strong> Specialized Libraries"
    when '3x11' then "<strong>#{sec}.</strong> X11 Library"
    when '3xt'  then "<strong>#{sec}.</strong> X Toolkit"
    when '4'    then "<strong>#{sec}.</strong> File Formats"
    when '5'    then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '7'    then "<strong>#{sec}.</strong> Special Files"
    when '8'    then "<strong>#{sec}.</strong> Maintenance Procedures"
    when 'l'    then 'Local Commands'
    else "Section #{sec}"
    end
  end

end
