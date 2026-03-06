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

require_relative './en_us'

class NEWS_os::V3_3_ja_JP
  class Troff < ::NEWS_os::V3_3_en_US::Troff

    def initialize(source)
      @language ||= 'ja'
      source.lines.collect! { |l| l.force_encoding(Encoding::Shift_JIS).encode!(Encoding::UTF_8) }
      @related_info_heading ||= %r{関連事項}u
      super(source)
    end

    def so(name, breaking: nil)
      super(name, breaking: breaking) do |lines|
      lines.collect! { |l| l.force_encoding(Encoding::Shift_JIS).encode!(Encoding::UTF_8) }
      end
    end

  end
end
