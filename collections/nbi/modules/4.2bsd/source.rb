# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/05/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# ISI/NBI 4.2BSD Platform Overrides (tmac.an.new)
#

module NBI_4_2BSD
  class Source < Source
    def initialize(file, **kwargs, &block)
      case File.basename(file)
      when 'list', 'make', 'script.print'
        raise ManualIsBlacklisted, 'garbage'
      end
      super
    end
  end
end
