# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/23/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# ISC/Kodak/SunSoft Interactive UNIX Platform Overrides
#

require_relative 'modules/interactive/nroff'
require_relative 'modules/interactive/troff'
require_relative 'modules/interactive_2.2'
require_relative 'modules/interactive_3.2r4.1'

module Interactive

  def self.name_for_section(sec)
    case sec.downcase
    when '1'    then "<strong>#{sec}.</strong> Commands"
    when '1c'   then "<strong>#{sec}.</strong> Communications Commands"
    when '1g'   then "<strong>#{sec}.</strong> Graphics Commands"
    when '1m'   then "<strong>#{sec}.</strong> Maintenance Commands"
    when '1p'   then "<strong>#{sec}.</strong> POSIX Commands"
    when '2'    then "<strong>#{sec}.</strong> System Calls"
    when '2p'   then "<strong>#{sec}.</strong> POSIX System Calls"
    when '3'    then "<strong>#{sec}.</strong> Subroutines and Libraries"
    when '3c'   then "<strong>#{sec}.</strong> C Library"
    when '3m'   then "<strong>#{sec}.</strong> Math Library"
    when '3n'   then "<strong>#{sec}.</strong> Network Support Library"
    when '3p'   then "<strong>#{sec}.</strong> POSIX Compatible Routines"
    when '3s'   then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3x'   then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '4'    then "<strong>#{sec}.</strong> File Formats"
    when '4p'   then "<strong>#{sec}.</strong> POSIX File Formats"
    when '5'    then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '5p'   then "<strong>#{sec}.</strong> POSIX Facilities"
    when '7'    then "<strong>#{sec}.</strong> Special Files"
    when '7n'   then "<strong>#{sec}.</strong> Networking Facilities"
    when '8'    then "<strong>#{sec}.</strong> Maintenance Commands"
    else "Section #{sec}"
    end
  end

end
