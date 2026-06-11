# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/31/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# Aegis SR8.1 Platform Overrides
#

module Aegis
  module SR8_1

    class Manual < Manual ; end
    class Help < Help ; end

    class Nroff < Nroff
      def initialize(source, **kwargs)
        case source.file
        when 'aux.release_notes.sr8.1' then @lines_per_page = 63
        end
        super(source, **kwargs)
      end
    end

    def self.name_for_section(sec)
      Aegis.name_for_section(sec)
    end

  end
end
