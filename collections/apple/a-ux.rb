# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/28/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Apple A/UX Platform Overrides
#

require_relative 'modules/a-ux/nroff'
require_relative 'modules/a-ux_0.7'
require_relative 'modules/a-ux_2.0'
require_relative 'modules/a-ux_3.0.1'

module A_UX

  def self.name_for_section(sec)
    case sec.downcase
    when '1'   then "<strong>#{sec}.</strong> Commands"
    when '1c'  then "<strong>#{sec}.</strong> Communications Commands"
    when '1g'  then "<strong>#{sec}.</strong> Graphics Commands"
    when '1m'  then "<strong>#{sec}.</strong> Maintenance Commands"
    when '1n'  then "<strong>#{sec}.</strong> Network Commands"
    when '1x'  then "<strong>#{sec}.</strong> X11 Commands"
    when '2'   then "<strong>#{sec}.</strong> System Calls"
    when '2n'  then "<strong>#{sec}.</strong> Socket Library"
    when '2p'  then "<strong>#{sec}.</strong> POSIX System Calls"
    when '3'   then "<strong>#{sec}.</strong> Subroutines and Libraries"
    when '3c'  then "<strong>#{sec}.</strong> C Library"
    when '3f'  then "<strong>#{sec}.</strong> FORTRAN Library"
    when '3m'  then "<strong>#{sec}.</strong> Math Library"
    when '3n'  then "<strong>#{sec}.</strong> Network Support Library"
    when '3p'  then "<strong>#{sec}.</strong> POSIX Compatibility Routines"
    when '3s'  then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3x'  then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '3xt' then "<strong>#{sec}.</strong> X Toolkit"
    when '4'   then "<strong>#{sec}.</strong> File Formats"
    when '4n'  then "<strong>#{sec}.</strong> Networking File Formats"
    when '5'   then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '5p'  then "<strong>#{sec}.</strong> Network Protocols"
    when '6'   then "<strong>#{sec}.</strong> Games"
    when '7'   then "<strong>#{sec}.</strong> Special Files"
    when '7n'  then "<strong>#{sec}.</strong> Network Special Files"
    when '7p'  then "<strong>#{sec}.</strong> POSIX Special Files"
    when '8'   then "<strong>#{sec}.</strong> Maintenance Procedures"
    else "Section #{sec}"
    end
  end

end
