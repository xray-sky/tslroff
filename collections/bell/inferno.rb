# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/14/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Inferno Platform Overrides
#
# 1e has HTML format input. This should be interesting.
# 3e has troff format input, but where are the macro files?
#

require_relative 'modules/inferno/troff'
require_relative 'modules/inferno_1ed'
require_relative 'modules/inferno_1.1ed'
require_relative 'modules/inferno_3ed'
require_relative 'modules/inferno_4ed'

module Inferno

  def self.name_for_section(sec)
    case sec.downcase
    when '1'    then "<strong>#{sec}.</strong> Commands"
    #when '1e'   then '' # ??
    when '2'    then "<strong>#{sec}.</strong> Limbo Modules and Inferno System Calls"
    when '3'    then "<strong>#{sec}.</strong> Kernel Devices"
    when '4'    then "<strong>#{sec}.</strong> File Services"
    when '5'    then "<strong>#{sec}.</strong> Styx File Service Protocol"
    when '6'    then "<strong>#{sec}.</strong> File Formats and Conventions"
    when '7'    then "<strong>#{sec}.</strong> Databases and Database Access Modules"
    when '8'    then "<strong>#{sec}.</strong> Administrative Modules and System Services"
    when '9'    then "<strong>#{sec}.</strong> Limbo/Tk"
    when '10'   then "<strong>#{sec}.</strong> Build Environment and Device Drivers"
    when '10.1' then "<strong>#{sec}.</strong> Kernel Build Commands"
    when '10.2' then "<strong>#{sec}.</strong> Kernel Functions"
    when '10.6' then "<strong>#{sec}.</strong> File Formats"
    when '10.8' then "<strong>#{sec}.</strong> Bootstrap Procedures"
    else "Section #{sec}"
    end
  end

end
