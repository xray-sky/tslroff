# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/25/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Data General DG/UX 4.30 Version Overrides
#

module DG_UX
  module V4_30

    class Nroff < Nroff
      def initialize(source, **kwargs)
        @heading_detection ||= %r(^\s{5}(?<section>[A-Z][A-Za-z\s]+)$)
        super(source, **kwargs)
      end
    end

    def self.name_for_section(sec)
      DG_UX.name_for_section(sec)
    end

  end
end
