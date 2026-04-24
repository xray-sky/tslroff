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

    def initialize(source, macros: nil)
      @manual_entry ||= source.file.sub(/\.(\d\S?)$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      super(source, macros: macros)
    end

  end
end
