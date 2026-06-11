# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 07/01/26.
# Copyright 2026 Typewritten Software. All rights reserved.
#
#
# Dell SVR4 Platform Overrides
#

require_relative 'modules/svr4/manual'

module Dell_SVR4

  def self.name_for_section(sec)
    case sec.downcase
    when '1'    then "<strong>#{sec}.</strong> Commands"
    when '1c'   then "<strong>#{sec}.</strong> Communication Commands"
    when '1d'   then "<strong>#{sec}.</strong> MS-DOS Commands"
    when '1f'   then "<strong>#{sec}.</strong> FMLI Commands"
    when '1g'   then "<strong>#{sec}.</strong> Graphics Commands"
    when '1l'   then "<strong>#{sec}.</strong> Local Commands"
    when '1m'   then "<strong>#{sec}.</strong> Maintenance Commands"
    when '1x'   then "<strong>#{sec}.</strong> Xenix Compatibility and Motif Commands"
    when '2'    then "<strong>#{sec}.</strong> System Calls"
    when '3'    then "<strong>#{sec}.</strong> Subroutines and Libraries"
    when '3c'   then "<strong>#{sec}.</strong> C Library"
    when '3e'   then "<strong>#{sec}.</strong> ELF Library"
    when '3g'   then "<strong>#{sec}.</strong> General Purpose Library"
    when '3m'   then "<strong>#{sec}.</strong> Math Library"
    when '3n'   then "<strong>#{sec}.</strong> Network Support Libraries"
    when '3s'   then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3t'   then "<strong>#{sec}.</strong> TIFF Library"
    when '3w'   then "<strong>#{sec}.</strong> OpenLook Library"
    when '3x'   then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '3x11' then "<strong>#{sec}.</strong> X11 Library"
    when '3xt'  then "<strong>#{sec}.</strong> X Toolkit"
    when '4'    then "<strong>#{sec}.</strong> File Formats"
    when '5'    then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '6'    then "<strong>#{sec}.</strong> Games and Demos"
    when '7'    then "<strong>#{sec}.</strong> Special Files"
    when '8'    then "<strong>#{sec}.</strong> Network Maintenance Facilities"
    else "Section #{sec}"
    end
  end

end


