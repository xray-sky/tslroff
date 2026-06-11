# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/24/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Data General DG/UX Platform Overrides
#

module DG_UX
  class Source < Source

    def initialize(file, **kwargs, &block)
      kwargs[:encoding] ||= Encoding::ISO_8859_1
      super(file, **kwargs, &block)
    end

  end
end


