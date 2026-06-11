# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/04/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Gould G-NIX Platform Overrides
#
# TODO:
# √ apl.1 :: overstrikes -> I-beam is >2chr; character centers not aligned, e.g. lamp
#            might be best just to rewrite them as single chars, if possible
#

module GDT_UNX
  class Nroff < Nroff

    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.(\d\S?)$/, '')
      @manual_section ||= Regexp.last_match[1]
      super(source, **kwargs)
    end

  end
end
