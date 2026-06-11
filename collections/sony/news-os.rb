# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/12/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# NEWS-os Platform Overrides
#

require_relative 'modules/news-os/troff'
require_relative 'modules/news-os_3.3_en_us'
require_relative 'modules/news-os_3.3_ja_jp'
require_relative 'modules/news-os_4.1c_en_us'
require_relative 'modules/news-os_4.1c_ja_jp'
require_relative 'modules/news-os_4.2.1r_en_us'
require_relative 'modules/news-os_4.2.1r_ja_jp'
require_relative 'modules/news-os_5.0.1'

module NEWS_os

  def self.name_for_section(sec)
    case sec.downcase
    when '1'      then "<strong>#{sec}.</strong> Commands"
    when '1a'     then "<strong>#{sec}.</strong> Maintenance Commands"
    when '1c'     then "<strong>#{sec}.</strong> Communications Commands"
    when '1f'     then "<strong>#{sec}.</strong> FMLI Commands"
    when '1g'     then "<strong>#{sec}.</strong> Graphics Commands"
    when '1j'     then "<strong>#{sec}.</strong> Japanese Commands"
    when '1v'     then "<strong>#{sec}.</strong> POSIX/System V Commands"
    when '1m'     then "<strong>#{sec}.</strong> Maintenance Commands"
    when '2'      then "<strong>#{sec}.</strong> System Calls"
    when '2v'     then "<strong>#{sec}.</strong> POSIX/System V System Calls"
    when '3'      then "<strong>#{sec}.</strong> C Library"
    when '3c'     then "<strong>#{sec}.</strong> Compatibility Routines"
    when '3f'     then "<strong>#{sec}.</strong> FORTRAN Library"
    when '3f7768' then "<strong>#{sec}.</strong> M68k FORTRAN Library"
    when '3j'     then "<strong>#{sec}.</strong> Japanese Language Processing Functions"
    when '3m'     then "<strong>#{sec}.</strong> Math Library"
    when '3n'     then "<strong>#{sec}.</strong> Network Support Library"
    when '3v'     then "<strong>#{sec}.</strong> POSIX Compatibility Routines"
    when '3r'     then "<strong>#{sec}.</strong> RPC Library"
    when '3s'     then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3x'     then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '3x11'   then "<strong>#{sec}.</strong> X11 Library"
    when '3xext'  then "<strong>#{sec}.</strong> X11 Extensions"
    when '3xi'    then "<strong>#{sec}.</strong> X Input Library"
    when '3xm'    then "<strong>#{sec}.</strong> Motif Library"
    when '3xt'    then "<strong>#{sec}.</strong> X Toolkit"
    when '4'      then "<strong>#{sec}.</strong> Special Files"
    when '4c'     then "<strong>#{sec}.</strong> Network File Formats"
    when '4f'     then "<strong>#{sec}.</strong> Network Protocol Families"
    when '4n'     then "<strong>#{sec}.</strong> Network Facilities"
    when '4p'     then "<strong>#{sec}.</strong> Network Protocols"
    when '4v'     then "<strong>#{sec}.</strong> POSIX/System V Special Files"
    when '5'      then "<strong>#{sec}.</strong> File Formats"
    when '5v'     then "<strong>#{sec}.</strong> POSIX/System V File Formats"
    when '6'      then "<strong>#{sec}.</strong> Games"
    when '7'      then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '8'      then "<strong>#{sec}.</strong> Maintenance Procedures"
    when '8c'     then "<strong>#{sec}.</strong> Network Services"
    else "Section #{sec}"
    end
  end

end
