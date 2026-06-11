# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Ardent SysV Platform Overrides
#

require_relative 'modules/sysv/troff'
require_relative 'modules/sysv_r3.0'
require_relative 'modules/sysv_r4.1'
require_relative 'modules/sysv_r4.2'

module Ardent_SysV

  def self.name_for_section(sec)
    case sec.downcase
    when '1'    then "<strong>#{sec}.</strong> Commands"
    when '1b'   then "<strong>#{sec}.</strong> 4.3BSD Compatibility Commands"
    when '1c'   then "<strong>#{sec}.</strong> Communications Commands"
    when '1g'   then "<strong>#{sec}.</strong> Graphics Commands"
    when '1m'   then "<strong>#{sec}.</strong> Maintenance Commands"
    when '1x'   then "<strong>#{sec}.</strong> Motif Commands"
    when '2'    then "<strong>#{sec}.</strong> System Calls"
    when '3'    then "<strong>#{sec}.</strong> Subroutines and Libraries"
    when '3c'   then "<strong>#{sec}.</strong> Compatibility Routines"
    when '3d'   then "<strong>#{sec}.</strong> Dore Library"
    when '3m'   then "<strong>#{sec}.</strong> Math Library"
    when '3n'   then "<strong>#{sec}.</strong> Network Support Library"
    when '3p'   then "<strong>#{sec}.</strong> PHIGS"
    when '3p+'  then "<strong>#{sec}.</strong> PHIGS PLUS"
    when '3s'   then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3x'   then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '3x11' then "<strong>#{sec}.</strong> X11 Library"
    when '3xh'  then "<strong>#{sec}.</strong> X Toolkit Intrinsics Library"
    when '3xt'  then "<strong>#{sec}.</strong> X Toolkit"
    when '4'    then "<strong>#{sec}.</strong> File Formats"
    when '5'    then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '7'    then "<strong>#{sec}.</strong> Special Files"
    when '7p'   then "<strong>#{sec}.</strong> PHIGS PEX-SI"
    when '8'    then "<strong>#{sec}.</strong> Maintenance Procedures"
    when '8c'   then "<strong>#{sec}.</strong> Network Services"
    else "Section #{sec}"
    end
  end

end
