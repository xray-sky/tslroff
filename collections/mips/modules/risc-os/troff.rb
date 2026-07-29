# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/2/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# mips RISC/os Platform Overrides
#

module RISC_os
  class Troff < Troff::Man

    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.(\d\S?)$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      super
    end

  end
end
