# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/04/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#

require_relative 'modules/bsd/nroff'
require_relative 'modules/bsd/troff'
require_relative 'modules/1bsd'
require_relative 'modules/2.8bsd'
require_relative 'modules/2.9bsd'
require_relative 'modules/2.11bsd'
require_relative 'modules/3bsd'
require_relative 'modules/4.1bsd'
require_relative 'modules/4.3bsd-vax-mit'

module BSD

  def self.name_for_section(sec)
    case sec.downcase
    when '1'    then "<strong>#{sec}.</strong> Commands"
    when '1c'   then "<strong>#{sec}.</strong> Communications Commands"
    when '1g'   then "<strong>#{sec}.</strong> Graphics Commands"
    when '1l'   then "<strong>#{sec}.</strong> Local Commands"
    when '1m'   then "<strong>#{sec}.</strong> Maintenance Commands"
    when '2'    then "<strong>#{sec}.</strong> System Calls"
    when '2j'   then "<strong>#{sec}.</strong> Job Control System Calls"
    when '2v'   then "<strong>#{sec}.</strong> Virtual Memory System Calls"
    when '2x'   then "<strong>#{sec}.</strong> Extended System Calls"
    when '3'    then "<strong>#{sec}.</strong> Subroutines and Libraries"
    when '3c'   then "<strong>#{sec}.</strong> Compatibility Routines"
    when '3f'   then "<strong>#{sec}.</strong> FORTRAN Library"
    when '3j'   then "<strong>#{sec}.</strong> Job Control Facilities"
    when '3m'   then "<strong>#{sec}.</strong> Math Library"
    when '3n'   then "<strong>#{sec}.</strong> Network Library"
    when '3s'   then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3x'   then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '4'    then "<strong>#{sec}.</strong> Special Files"
    when '4f'   then "<strong>#{sec}.</strong> Network Protocol Families"
    when '4n'   then "<strong>#{sec}.</strong> Network Facilities"
    when '4p'   then "<strong>#{sec}.</strong> Network Protocols"
    when '5'    then "<strong>#{sec}.</strong> File Formats"
    when '5l'   then "<strong>#{sec}.</strong> Local File Formats"
    when '6'    then "<strong>#{sec}.</strong> Games"
    when '7'    then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '8'    then "<strong>#{sec}.</strong> Maintenance Commands"
    when '8c'   then "<strong>#{sec}.</strong> Communications Maintenance Commands"
    when '8v'   then "<strong>#{sec}.</strong> Virtual Memory Maintenance Commands"
    when 'ucb'  then "<strong>#{sec}.</strong> Berkeley-specific Commands"
    when 'i'    then "<strong>#{sec}.</strong> Commands"
    when 'ii'   then "<strong>#{sec}.</strong> System Calls"
    when 'iii'  then "<strong>#{sec}.</strong> Subroutines"
    when 'iv'   then "<strong>#{sec}.</strong> Special Files"
    when 'v'    then "<strong>#{sec}.</strong> File Formats and Conventions"
    when 'vi'   then "<strong>#{sec}.</strong> User-maintained Programs"
    when 'vii'  then "<strong>#{sec}.</strong> User-maintained Subroutines"
    when 'viii' then "<strong>#{sec}.</strong> Maintenance"
    else "Section #{sec}"
    end
  end

end
