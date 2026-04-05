# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/31/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# NEWS-os 3.3 (SJIS) Platform Overrides
#
# TODO
#

require_relative 'en_us'

module NEWS_os
  module V3_3_ja_JP
    class Source < Source
      def initialize(file, **kwargs, &block)
        kwargs[:encoding] ||= Encoding::Shift_JIS
        super(file, **kwargs, &block)
      end
    end

    class Manual < Manual
      def initialize(file, **kwargs)
        @language ||= 'ja'
        super(file, **kwargs)
      end
    end

    class Troff < V3_3_en_US::Troff
      def initialize(source)
        @related_info_heading ||= %r{関連事項}u
        super(source)
      end

      # isn't there some way of having .so automatically look up the right Source class?
      def so(name, breaking: nil)
        super(name, breaking: breaking, source_class: Source)
      end
    end
  end
end
