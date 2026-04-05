# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 01/4/26.
# Copyright 2026 Typewritten Software. All rights reserved.
#
#
# SGI 4D1 UNIX & IRIX Platform Overrides
#
#
# TODO
#   title line incl. in SEE ALSO refs (e.g. admin.1.z)
#

module IRIX
  class Nroff < Nroff
    def initialize(source)
      @manual_entry ||= source.file.sub(/\.(\d\S?)$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      @heading_detection ||= %r(^\s{5}(?<section>[A-Z][A-Za-z\s]+)$)
      @title_detection ||= %r{^\s+(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))\s.+?\s\k<manentry>$}
      super(source)
    end
  end

  module V6_5
    class Nroff < Nroff
      def initialize(source)
        @manual_entry ||= source.file.sub(/\.z$/, '')
        @heading_detection ||= %r(^\s{0,5}(?<section>[A-Z][A-Za-z\s]+)$)
        @title_detection ||= %r{^\s{0,5}(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))\s.+?\s\k<manentry>$}
        super(source)
      end
    end
  end
end

