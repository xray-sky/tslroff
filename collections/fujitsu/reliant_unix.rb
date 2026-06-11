# frozen_string_literal: true
#
# Created by R. Stricklin <bear@typewritten.org> on 06/8/26.
# Copyright 2026 Typewritten Software. All rights reserved.
#
# Fujitsu-Siemens Reliant UNIX Platform Overrides
#

require_relative 'modules/reliant_unix/manual'

module Reliant_UNIX

  def self.name_for_section(sec)
    case sec.downcase
    when '1'       then "<strong>#{sec}.</strong> Commands"
    when '1-ucb'   then "<strong>#{sec}.</strong> BSD Compatibility Commands"
    when '1-ufs'   then "<strong>#{sec}.</strong> UFS Commands"
    when '1-vxfs'  then "<strong>#{sec}.</strong> VxFS Commands"
    when '1c'      then "<strong>#{sec}.</strong> Communications Commands"
    when '1f'      then "<strong>#{sec}.</strong> FMLI Commands"
    when '1m'      then "<strong>#{sec}.</strong> Maintenance Commands"
    when '1m-nfs'  then "<strong>#{sec}.</strong> NFS Maintenance Commands"
    when '1m-ucb'  then "<strong>#{sec}.</strong> BSD Compatible Maintenance Commands"
    when '1m-ufs'  then "<strong>#{sec}.</strong> UFS Maintenance Commands"
    when '1m-vxfs' then "<strong>#{sec}.</strong> VxFS Maintenance Commands"
    when '1x'      then "<strong>#{sec}.</strong> X11 Commands"
    when '2'       then "<strong>#{sec}.</strong> System Calls"
    when '3'       then "<strong>#{sec}.</strong> Functions and Libraries"
    when '3-thr'   then "<strong>#{sec}.</strong> DCE Threads Library"
    when '3-ucb'   then "<strong>#{sec}.</strong> BSD Compatibility Routines"
    when '3c'      then "<strong>#{sec}.</strong> C Library"
    when '3c-ucb'  then "<strong>#{sec}.</strong> BSD Compatible C Library"
    when '3e'      then "<strong>#{sec}.</strong> ELF Library"
    when '3g'      then "<strong>#{sec}.</strong> General Purpose Library"
    when '3k'      then "<strong>#{sec}.</strong> Kanji Processing Routines"
    when '3m'      then "<strong>#{sec}.</strong> Math Library"
    when '3n'      then "<strong>#{sec}.</strong> Network Support Library"
    when '3n-xs'   then "<strong>#{sec}.</strong> X/Open Sockets Library"
    when '3s'      then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3s-ucb'  then "<strong>#{sec}.</strong> BSD Compatible Standard I/O Library"
    when '3w'      then "<strong>#{sec}.</strong> International Library"
    when '3x'      then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '4'       then "<strong>#{sec}.</strong> File Formats"
    when '4-ufs'   then "<strong>#{sec}.</strong> UFS File Formats"
    when '4-vxfs'  then "<strong>#{sec}.</strong> VxFS File Formats"
    when '5'       then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '7'       then "<strong>#{sec}.</strong> Special Files"
    when '8'       then "<strong>#{sec}.</strong> Maintenance Procedures"
    else "Section #{sec}"
    end
  end

end
