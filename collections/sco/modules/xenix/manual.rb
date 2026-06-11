# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/23/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# SCO Xenix Platform Overrides
#
# TODO
# √ master.list(C) - blacklist (not a manual page)
#

require_relative 'nroff'

module Xenix
  class Manual < Manual

    def initialize(source, **kwargs)
      case File.basename(source)
      when 'master.list.C' then raise ManualIsBlacklisted, "not a manual entry"
      end
      super(source, **kwargs)
    end

  end
end
