# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/06/23.
# Copyright 2023 Typewritten Software. All rights reserved.
#
#
# 3BSD Platform Overrides (tmac.an.new)
#
# TODO
#

module BSD
  module V3

    class Nroff < Nroff ; end

    class Troff < Troff
      # tmac.an.new
      def UC(v = nil, *_args)
        ds(']W 3rd Berkeley Distribution')
      end
    end

    def self.name_for_section(sec)
      BSD.name_for_section(sec)
    end

  end
end
