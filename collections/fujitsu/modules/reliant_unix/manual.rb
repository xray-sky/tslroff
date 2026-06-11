# frozen_string_literal: true
#
# Created by R. Stricklin <bear@typewritten.org> on 06/8/26.
# Copyright 2026 Typewritten Software. All rights reserved.
#
# Fujitsu-Siemens Reliant UNIX Platform Overrides
#

require_relative 'source'
require_relative 'nroff'

module Reliant_UNIX

  class Manual < Manual
    def initialize(file, **kwargs)
      @language = 'de' if File.dirname(file).include?('_D') # REVIEW is this redundant with TextFormatter's?
      super(file, **kwargs)
    end
  end

end
