# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/04/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Bell UNIX Platform Overrides
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
end
