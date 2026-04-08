# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/07/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Intergraph CLIX 3.1r7.6.28 Platform Overrides
#

module CLIX
  module V3_1r7_6_28
    class Source < Source
      def initialize(file, **kwargs, &block)
        case File.basename file
        when 'convert.Z' then raise ManualIsBlacklisted, 'apparently not a manual entry'
        end
        super(file, **kwargs, &block)
      end
    end

    class Nroff < Nroff

      def initialize(source)
        case source.file
        when 'browse.1.Z', 'genmenu.1.Z', 'mrgpanel.1.Z' # REVIEW: should this be unbundled (IFORMS/S product)
          @heading_detection = %r(^\s{4}(?<section>[A-Z][A-Za-z\s]+)$)
          @title_detection = %r{^\s{4}(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))\s.+?\s\k<manentry>$}
        end
        super(source)
      end

    end
  end
end
