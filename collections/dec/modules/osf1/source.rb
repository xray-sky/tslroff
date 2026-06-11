# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# OSF/1 & Digital UNIX (Tru64) Platform Overrides
#

module OSF1

  class Source < Source
    def initialize(file, **kwargs, &block)
      case File.dirname file
      when /SJIS/ then kwargs[:encoding] = Encoding::Shift_JIS
      end
      super(file, **kwargs, &block)
    end
  end

end

