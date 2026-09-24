# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/06/23.
# Copyright 2023 Typewritten Software. All rights reserved.
#
#
# 2.8BSD Platform Overrides (same as UNIX 7th Edition)
#
# TODO
#

module BSD
  module V2_8

    class Nroff < Nroff ; end

    class Troff < ::UNIX::V7::Troff
      def initialize(source, **kwargs)
        @manual_entry ||= source.file.sub(/\.(?:[u\d]\S?)$/, '')
        super
      end
    end

    def self.name_for_section(sec)
      BSD.name_for_section(sec)
    end

  end
end
