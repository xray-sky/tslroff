# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/10/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# Intergraph CLIX Platform Overrides
#

require_relative 'modules/clix/nroff'
require_relative 'modules/clix_3.1r7.6.22'
require_relative 'modules/clix_3.1r7.6.28'

module CLIX

  def self.name_for_section(sec)
    case sec.downcase
    when '0'  then "<strong>#{sec}.</strong> Header Files"
    when '1'  then "<strong>#{sec}.</strong> Commands"
    when '2'  then "<strong>#{sec}.</strong> System Calls"
    when '3'  then "<strong>#{sec}.</strong> Functions and Libraries"
    when '4'  then "<strong>#{sec}.</strong> File Formats"
    when '7'  then "<strong>#{sec}.</strong> Device Special Files"
    when '8'  then "<strong>#{sec}.</strong> Maintenance Commands"
    else "Section #{sec}"
    end
  end

end


