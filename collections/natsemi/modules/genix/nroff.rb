# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 10/05/26.
# Copyright 2026 Typewritten Software. All rights reserved.
#
#
# National Semiconductor GENIX Platform Overrides
#

module GENIX
  class Nroff < Nroff

    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.([\dZz]\S*?)$/, '')
      @heading_detection ||= %r(^\s{6}(?<section>[A-Z][A-Za-z\s]+)$)
      @title_detection ||= %r{^\s{6}(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))\s.+?\s\k<manentry>$}
      super
    end

  end
end
