# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# OSF/1 & Digital UNIX (Tru64) Platform Overrides
#

require_relative 'source'
require_relative 'html'
require_relative 'nroff'
require_relative 'troff'

module OSF1

  class Manual < Manual
    def initialize(source, **kwargs)
      case File.dirname source
      when /SJIS/ then @language ||= 'ja'
      end
      super(source, **kwargs)
    end
  end

end

