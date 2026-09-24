# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/10/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Plan9 Platform Overrides
#

require_relative 'modules/plan9/troff'

module Plan9

  def self.name_for_section(sec)
    case sec.downcase
    when '1'  then "<strong>#{sec}.</strong> Commands"
    when '2'  then "<strong>#{sec}.</strong> System Calls and Libraries"
    when '2g' then "<strong>#{sec}.</strong> Graphics Library"
    when '2s' then "<strong>#{sec}.</strong> Standard I/O Library"
    when '2x' then "<strong>#{sec}.</strong> Specialized Libraries"
    when '3'  then "<strong>#{sec}.</strong> Kernel Devices"
    when '4'  then "<strong>#{sec}.</strong> File Services"
    when '5'  then "<strong>#{sec}.</strong> Plan 9 File Protocol"
    when '6'  then "<strong>#{sec}.</strong> File Formats"
    when '7'  then "<strong>#{sec}.</strong> Databases and Access Programs"
    when '8'  then "<strong>#{sec}.</strong> Maintenance Commands"
    # Inferno manuals for 3e Vita Nuova CD
    when '9'    then "<strong>#{sec}.</strong> Limbo/Tk"
    when '10'   then "<strong>#{sec}.</strong> Inferno Build Environment and Device Drivers"
    when '10.1' then "<strong>#{sec}.</strong> Inferno Kernel Build Commands"
    when '10.2' then "<strong>#{sec}.</strong> Inferno Kernel Functions"
    when '10.6' then "<strong>#{sec}.</strong> Inferno File Formats"
    when '10.8' then "<strong>#{sec}.</strong> Inferno Bootstrap Procedures"
    else "Section #{sec}"
    end
  end

end
