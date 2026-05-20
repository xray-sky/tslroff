# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/9/26.
# Copyright 2026 Typewritten Software. All rights reserved.
#
#
# Apple A/UX 2.0 Version Overrides
#

module A_UX
  module V2_0
    class Nroff < Nroff ; end
    def self.name_for_section(sec)
      A_UX.name_for_section(sec)
    end
  end
end
