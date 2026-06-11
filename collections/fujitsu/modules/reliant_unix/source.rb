# frozen_string_literal: true
#
# Created by R. Stricklin <bear@typewritten.org> on 06/8/26.
# Copyright 2026 Typewritten Software. All rights reserved.
#
# Fujitsu-Siemens Reliant UNIX Platform Overrides
#

module Reliant_UNIX

  class Source < Source
    def initialize(file, **kwargs)
      kwargs[:encoding] = Encoding::ISO_8859_1
      super(file, **kwargs)
    end
  end

end
