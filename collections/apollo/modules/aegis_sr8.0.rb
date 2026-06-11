# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/31/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# Aegis SR8.0 Platform Overrides
#

module Aegis
  module SR8_0

    class Source < Source
      def initialize(file, **kwargs, &block)
        super(file, **kwargs, &block)
        case @file
        when 'chgrp.1' then patch_line(1, /8/, '1', global: true)
        end
      end
    end

    class Manual < Manual ; end
    class Help < Help ; end
    class Nroff < Nroff ; end
    class Troff < Troff ; end

    def self.name_for_section(sec)
      Aegis.name_for_section(sec)
    end

  end
end
