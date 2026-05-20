# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/04/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Bell UNIX Platform Overrides
#
# TODO
#

module UNIX
  class Troff < Troff::Man
    alias :LP :P

    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.(\d\S?)$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      super(source, **kwargs)
    end

    # .so with absolute path, headers in /usr/include
    def so(name, breaking: nil, basedir: nil)
      basedir ||= "#{@source.dir}#{"/../.." if name.start_with?('/')}"
      super(name, breaking: breaking, basedir: basedir)
    end

  end

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
