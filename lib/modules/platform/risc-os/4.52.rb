# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/03/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# mips RISC/os 4.52 Platform Overrides
#
# TODO:
#

module RISC_os
  module V4_52
    class Nroff < Nroff

      def initialize source
        case source.file
        when /1prom$/
          @manual_entry ||= source.file.sub(/\.1prom$/, '')
          @heading_detection ||= %r{^\s{5}(?<section>[A-Z][A-Za-z0-9\s]+)$}
          @title_detection ||= %r{^\s{5}(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)(?:-(?<systype>\S+?))?\))\s.+?\s\k<manentry>$}
        when 'newsetup.1', 'newsgroups.1', 'patch.1', 'Pnews.1', 'Rnmail.1'
          # have section as 'entry(1 LOCAL)'
          @title_detection ||= %r{^(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)(?:\s(?<systype>\S+?))?\))}
        end
        super source
      end

      def page_title
        super.sub(/\S+$/, 'UMIPS RISC/os 4.52')
      end

    end
  end
end
