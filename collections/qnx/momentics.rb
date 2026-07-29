# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 07/26/26.
# Copyright 2026 Typewritten Software. All rights reserved.
#
#
# QNX Momentics Platform Overrides
#

require_relative 'modules/momentics/manual'

module Momentics

  def self.name_for_section(sec)
    case sec
    when '1'    then  "<strong>#{sec}.</strong> Commands"
    when '1L'   then  "<strong>#{sec}.</strong> Local Commands"
    when /^Bsp/ then sec.sub(%r{^Bsp}, 'BSP')
    when /^Ddk/ then sec.sub(%r{^Ddk}, 'DDK')
    when /^Ham/ then sec.gsub(%r{Ham}, 'HAM')
    when /^Ida/ then sec.sub(%r{^Ida tdk}, 'IDA TDK')
    when /^Ide/ then sec.sub(%r{^Ide}, 'IDE')
    else sec
    end
  end

end
