# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/06/23.
# Copyright 2023 Typewritten Software. All rights reserved.
#
#
# 1BSD Platform Overrides (same as UNIX 6th Edition)
#
# TODO
#

module BSD
  module V1
    class Troff < ::UNIX::V6::Troff ; end

    def self.name_for_section(sec)
      BSD.name_for_section(sec)
    end

  end
end
