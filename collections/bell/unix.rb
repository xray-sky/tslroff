# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/04/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Bell UNIX Platform Overrides
#

require_relative 'modules/unix/troff'
require_relative 'modules/unix_v6'
require_relative 'modules/unix_v7'
require_relative 'modules/unix_sys3'

module UNIX

  def self.name_for_section(sec)
    case sec.downcase
    when '1'  then "<strong>#{sec}.</strong> Commands"
    when '1c' then "<strong>#{sec}.</strong> Communications Commands"
    when '1g' then "<strong>#{sec}.</strong> Graphics Commands"
    when '1m' then "<strong>#{sec}.</strong> Maintenance Commands"
    when '2'  then "<strong>#{sec}.</strong> System Calls"
    when '3'  then "<strong>#{sec}.</strong> Library Functions"
    when '3f' then "<strong>#{sec}.</strong> FORTRAN Library" # 32V
    when '3m' then "<strong>#{sec}.</strong> Math Library"
    when '3s' then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3x' then "<strong>#{sec}.</strong> Specialized Functions"
    when '4'  then "<strong>#{sec}.</strong> Special Files"
    when '5'  then "<strong>#{sec}.</strong> File Formats and Conventions"
    when '6'  then "<strong>#{sec}.</strong> Games"
    when '7'  then "<strong>#{sec}.</strong> Macro Packages and Language Conventions"
    when '8'  then "<strong>#{sec}.</strong> Maintenance Commands"
    else "Section #{sec}"
    end
  end

end
