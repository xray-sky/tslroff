# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/16/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Amiga SVR4 2.01 Platform Overrides
#

module AMIX
  module V2_01

    class Nroff < Nroff ; end
    class Troff < Troff ; end

    def self.name_for_section(sec)
      AMIX.name_for_section(sec)
    end

  end
end
