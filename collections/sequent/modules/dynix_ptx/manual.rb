# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/14/23.
# Copyright 2023 Typewritten Software. All rights reserved.
#
#
# DYNIX Platform Overrides (tmac.an.new)
#

require_relative 'nroff'
require_relative 'troff'

module DYNIX_ptx
  class Manual < Manual

    def initialize(source, **kwargs)
      case File.basename source
      when 'Makefile' then raise ManualIsBlacklisted, 'not a manual entry'
      end
      super(source, **kwargs)
    end

  end
end
