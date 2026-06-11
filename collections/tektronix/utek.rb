# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 07/21/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# Tektronix UTek Platform Overrides
#

require_relative 'modules/utek/nroff'
require_relative 'modules/utek_6130-w2.3'

module UTek

  def self.name_for_section(sec)
    case sec.downcase
    when '1'     then "<strong>#{sec}.</strong> Commands"
    when '1c'    then "<strong>#{sec}.</strong> Communications Commands"
    when '1csh'  then "<strong>#{sec}.</strong> C Shell Commands"
    when '1g'    then "<strong>#{sec}.</strong> UTek Graphics Tools"
    when '1man'  then "<strong>#{sec}.</strong> Online Manual Commands"
    when '1mdqs' then "<strong>#{sec}.</strong> MDQS Commands"
    when '1mh'   then "<strong>#{sec}.</strong> RAND Mail Handler Commands"
    when '1n'    then "<strong>#{sec}.</strong> Network Commands"
    when '1net'  then "<strong>#{sec}.</strong> Network Commands"
    when '1px'   then "<strong>#{sec}.</strong> X10 Commands"
    when '1rcs'  then "<strong>#{sec}.</strong> RCS Commands"
    when '1sccs' then "<strong>#{sec}.</strong> SCCS Commands"
    when '1sh'   then "<strong>#{sec}.</strong> Bourne Shell Commands"
    when '1x'    then "<strong>#{sec}.</strong> X11 Commands"
    when '1x10'  then "<strong>#{sec}.</strong> X10 Commands"
    when '1x11'  then "<strong>#{sec}.</strong> X11 Commands"
    when '2'     then "<strong>#{sec}.</strong> System Calls"
    when '3'     then "<strong>#{sec}.</strong> Library Functions"
    when '3c'    then "<strong>#{sec}.</strong> C Library"
    when '3d'    then "<strong>#{sec}.</strong> Database Management Library"
    when '3f'    then "<strong>#{sec}.</strong> FORTRAN Library"
    when '3m'    then "<strong>#{sec}.</strong> Math Library"
    when '3mp'   then "<strong>#{sec}.</strong> Multiple Precision Math Library"
    when '3n'    then "<strong>#{sec}.</strong> Network Support Library"
    when '3px'   then "<strong>#{sec}.</strong> X10 Libraries"
    when '3pw'   then "<strong>#{sec}.</strong> PWB Routines"
    when '3r'    then "<strong>#{sec}.</strong> RPC Library"
    when '3s'    then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3t'    then "<strong>#{sec}.</strong> Curses and Termcap Libraries"
    when '3x'    then "<strong>#{sec}.</strong> X11 Library"
    when '3x10'  then "<strong>#{sec}.</strong> X10 Libraries"
    when '3x11'  then "<strong>#{sec}.</strong> X11 Library"
    when '4'     then "<strong>#{sec}.</strong> Special Files"
    when '4n'    then "<strong>#{sec}.</strong> Network Protocols, Families, and Interfaces"
    when '5'     then "<strong>#{sec}.</strong> File Formats"
    when '5g'    then "<strong>#{sec}.</strong> Graphics File Formats"
    when '5man'  then "<strong>#{sec}.</strong> Manual File Formats"
    when '5mdqs' then "<strong>#{sec}.</strong> MDQS File Formats"
    when '5n'    then "<strong>#{sec}.</strong> Network File Formats"
    when '5rcs'  then "<strong>#{sec}.</strong> RCS File Formats"
    when '5sccs' then "<strong>#{sec}.</strong> SCCS File Formats"
    when '5t'    then "<strong>#{sec}.</strong> Terminal File Formats"
    when '5x'    then "<strong>#{sec}.</strong> X11 File Formats"
    when '5x10'  then "<strong>#{sec}.</strong> X10 File Formats"
    when '5x11'  then "<strong>#{sec}.</strong> X11 File Formats"
    when '7'     then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '8'     then "<strong>#{sec}.</strong> Maintenance Commands"
    when '8c'    then "<strong>#{sec}.</strong> Network Services"
    when '8man'  then "<strong>#{sec}.</strong> Online Manual Maintenance Commands"
    when '8mdqs' then "<strong>#{sec}.</strong> MDQS Maintenance Commands"
    when '8mh'   then "<strong>#{sec}.</strong> RAND Mail Handler Maintenance Commands"
    when '8n'    then "<strong>#{sec}.</strong> Network Maintenance Commands"
    when '8x'    then "<strong>#{sec}.</strong> X11 Maintenance Commands"
    when '8x10'  then "<strong>#{sec}.</strong> X10 Maintenance Commands"
    when '8x11'  then "<strong>#{sec}.</strong> X11 Maintenance Commands"
    when 'l'     then "<strong>#{sec}.</strong> Local Commands"
    else "Section #{sec}"
    end
  end

end


