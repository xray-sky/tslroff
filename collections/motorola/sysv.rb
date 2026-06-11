# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Motorola SysV Platform Overrides
#

require_relative 'modules/sysv/source'
require_relative 'modules/sysv/nroff'
require_relative 'modules/sysv/troff'

module Motorola_SysV

  def self.name_for_section(sec)
    case sec.downcase
    when '1'     then "<strong>#{sec}.</strong> Commands"
    when '1c'    then "<strong>#{sec}.</strong> Communications Commands"
    when '1f'    then "<strong>#{sec}.</strong> FMLI Commands"
    when '1m'    then "<strong>#{sec}.</strong> Maintenance Commands"
    when '1n'    then "<strong>#{sec}.</strong> Network Commands"
    when '2'     then "<strong>#{sec}.</strong> System Calls"
    when '3'     then "<strong>#{sec}.</strong> Subroutines and Libraries"
    when '3a'    then "<strong>#{sec}.</strong> Audit Facility"
    when '3c'    then "<strong>#{sec}.</strong> C Library"
    when '3e'    then "<strong>#{sec}.</strong> ELF Library"
    when '3g'    then "<strong>#{sec}.</strong> General Purpose Library"
    when '3m'    then "<strong>#{sec}.</strong> Math Library"
    when '3n'    then "<strong>#{sec}.</strong> Network Support Libraries"
    when '3s'    then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3w'    then "<strong>#{sec}.</strong> International Functions"
    when '3x'    then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '4'     then "<strong>#{sec}.</strong> File Formats"
    when '4n'    then "<strong>#{sec}.</strong> Network File Formats"
    when '5'     then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '7'     then "<strong>#{sec}.</strong> Device Special Files"
    when '8'     then "<strong>#{sec}.</strong> Maintenance Procedures"
    when '8c'    then "<strong>#{sec}.</strong> Network Services"
    when 'd1dk'  then "<strong>#{sec}.</strong> DDI/DDK Data"
    when 'd2dk'  then "<strong>#{sec}.</strong> DDI/DDK Entry Point Routines"
    when 'd3d'   then "<strong>#{sec}.</strong> DDI Memory Access"
    when 'd3dk'  then "<strong>#{sec}.</strong> DDI/DDK Kernel Utility Routines"
    when 'd3dkx' then "<strong>#{sec}.</strong> DDI/DDK Kernel Error Routines"
    when 'd4dk'  then "<strong>#{sec}.</strong> DDI/DDK Kernel Data Structures"
    when 'd5dk'  then "<strong>#{sec}.</strong> DDI/DDK Kernel #defines"
    else "Section #{sec}"
    end
  end

end
