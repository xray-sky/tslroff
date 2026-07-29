# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 07/26/26.
# Copyright 2026 Typewritten Software. All rights reserved.
#
#
# QNX Momentics Platform Overrides
#

module Momentics
  class Troff < Troff::Man

    alias :LP :P

    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.(\d\S?)$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      super
    end

  end
end
