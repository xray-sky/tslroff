# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/2/26.
# Copyright 2026 Typewritten Software. All rights reserved.
#
#
# HP-UX Platform Overrides
#

module HPUX

  class Source < Source
    def initialize(file, **kwargs, &block)
      case File.dirname file
      when /SJIS/ then kwargs[:encoding] = Encoding::Shift_JIS
      end
      super
    end
  end

end

