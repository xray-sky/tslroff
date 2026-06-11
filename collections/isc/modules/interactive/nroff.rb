# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/23/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# ISC/Kodak/SunSoft Interactive UNIX Platform Overrides
#

module Interactive
  class Nroff < Nroff

    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.([n\d]\S*)$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      @heading_detection ||= %r(^\s{10}(?<section>[A-Z][A-Za-z\s]+)$)
      @title_detection ||= %r{^\s{10}(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))}
      super(source, **kwargs)
    end

  end
end
