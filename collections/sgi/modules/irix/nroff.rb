# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 01/4/26.
# Copyright 2026 Typewritten Software. All rights reserved.
#
#
# SGI 4D1 UNIX & IRIX Platform Overrides
#

module IRIX
  class Nroff < Nroff

    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.(\d\S?)(?:\.z)?$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      @heading_detection ||= %r(^\s{0,5}(?<section>[A-Z][A-Za-z\s]+)$)
      @title_detection ||= %r{^\s{0,5}(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))\s.+?\s\k<manentry>$}
      super(source, **kwargs)
    end

  end
end

