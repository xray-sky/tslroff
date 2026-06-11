# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# UCB Sprite Platform Overrides
#

require_relative 'modules/sprite/troff'

module Sprite

  def self.name_for_section(sec)
    case sec.downcase
    when '1'       then "<strong>#{sec}.</strong> Commands"
    when '1c'      then "<strong>#{sec}.</strong> Communications Commands"
    when '1l'      then "<strong>#{sec}.</strong> Commands"
    when '2'       then "<strong>#{sec}.</strong> System Calls"
    when '3'       then "<strong>#{sec}.</strong> Subroutines and Libraries"
    when '3c'      then "<strong>#{sec}.</strong> C Library"
    when '3f'      then "<strong>#{sec}.</strong> FORTRAN Library"
    when '3m'      then "<strong>#{sec}.</strong> Math Library"
    when '3n'      then "<strong>#{sec}.</strong> Network Support Library"
    when '3r'      then "<strong>#{sec}.</strong> RPC Library"
    when '3s'      then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3x'      then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '3xt'     then "<strong>#{sec}.</strong> X Toolkit"
    when '4'       then "<strong>#{sec}.</strong> Device Drivers"
    when '5'       then "<strong>#{sec}.</strong> File Formats"
    when '8'       then "<strong>#{sec}.</strong> Maintenance Commands"
    when 'l'       then "<strong>#{sec}.</strong> Local Commands"
    when 'admin'   then "Sprite Administrative Commands"
    when 'cmds'    then "Sprite Commands"
    when 'daemons' then "Sprite System Services"
    when 'dev'     then "Sprite Device Drivers"
    when 'files'   then "Sprite File Formats"
    when 'lib'     then "Sprite C Library"
    when 'tcl'     then "Tcl Command Language Library"
    else "Section #{sec}"
    end
  end

end
