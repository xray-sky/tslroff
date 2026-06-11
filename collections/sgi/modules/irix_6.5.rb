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
  module V6_5

    class Nroff < Nroff
      def initialize(source, **kwargs)
        @manual_entry ||= source.file.sub(/\.z$/, '')
        @heading_detection ||= %r(^\s{0,5}(?<section>[A-Z][A-Za-z\s]+)$)
        @title_detection ||= %r{^\s{0,5}(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))\s.+?\s(?:\k<manentry>|Last [Cc]hanged.*)$}
        super(source, **kwargs)
      end
    end

    def self.name_for_section(sec)
      IRIX.name_for_section(sec)
    end

  end
end

