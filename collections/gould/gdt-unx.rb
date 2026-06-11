# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/04/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Gould G-NIX Platform Overrides
#

require_relative 'modules/gdt-unx/source'
require_relative 'modules/gdt-unx/nroff'
require_relative 'modules/gdt-unx/troff'

module GDT_UNX

  def self.name_for_section(sec)
    case sec.downcase
    when '1'  then "<strong>#{sec}.</strong> Commands"
    when '1c' then "<strong>#{sec}.</strong> Communication Commands"
    when '1g' then "<strong>#{sec}.</strong> Graphics Commands"
    when '2'  then "<strong>#{sec}.</strong> System Calls"
    when '2j' then "<strong>#{sec}.</strong> Job Control System Calls"
    when '2v' then "<strong>#{sec}.</strong> Virtual Memory System Calls"
    when '3'  then "<strong>#{sec}.</strong> Subroutines and Libraries"
    when '3f' then "<strong>#{sec}.</strong> FORTRAN Library"
    when '3j' then "<strong>#{sec}.</strong> Job Control Library"
    when '3m' then "<strong>#{sec}.</strong> Math Library"
    when '3s' then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3x' then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '4'  then "<strong>#{sec}.</strong> Special Files"
    when '5'  then "<strong>#{sec}.</strong> File Formats"
    when '6'  then "<strong>#{sec}.</strong> Games"
    when '7'  then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '8'  then "<strong>#{sec}.</strong> Maintenance Procedures"
    when '9'  then "<strong>#{sec}.</strong> Gould-specific Commands"
    else "Section #{sec}"
    end
  end

end
