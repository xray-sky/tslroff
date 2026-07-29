# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 07/26/26.
# Copyright 2026 Typewritten Software. All rights reserved.
#
#
# QNX Momentics Platform Overrides
#

require_relative 'html'
require_relative 'troff'

module Momentics
  class Manual < Manual

    def initialize(source, **kwargs)
      case File.dirname(source)
      when /cpim_ch/ then @language = 'zh'
      when /kpim_ko/ then @language = 'ko'
      when /vpim_ja/ then @language = 'ja'
      end
      super
    end

    def output_directory
      # TODO dry
      @source.dir.include?('/usr/help') ? @source.dir.partition(%r{^.*/(?:usr/help)/?}).last : super
    end

  end
end
