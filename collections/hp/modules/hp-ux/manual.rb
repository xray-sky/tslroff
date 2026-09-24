# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/2/26.
# Copyright 2026 Typewritten Software. All rights reserved.
#
#
# HP-UX Platform Overrides
#

require_relative 'source'
require_relative 'troff'

module HPUX

  class Manual < Manual
    def initialize(source, **kwargs)
      case File.dirname source
      when /SJIS/ then @language ||= 'ja'
      end
      super
    end
  end

end


