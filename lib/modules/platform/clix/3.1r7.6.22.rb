# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/07/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Intergraph CLIX 3.1r7.6.22 Platform Overrides
#

module CLIX
  module V3_1r7_6_22
    class Source < Source
      def initialize(file, **kwargs, &block)
        case File.basename file
        when 'convert.Z' then raise ManualIsBlacklisted, 'apparently not a manual entry'
        end
        super(file, **kwargs, &block)
      end
    end
  end
end

