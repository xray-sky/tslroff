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
  class Manual < Manual
    def initialize file, vendor_class: nil, source_args: nil
      @language ||= 'ja'
      srcargs = source_args.dup || {}
      srcargs[:encoding] ||= Encoding::Shift_JIS
      super file, vendor_class: vendor_class, source_args: srcargs
    end
  end

  class Troff < NEWS_os::V3_3_en_US::Troff

    def initialize(source)
      @related_info_heading ||= %r{関連事項}u
      super(source)
    end

    # TODO revisit this if we ever fix .so to go through Source.new
    def so(name, breaking: nil)
      super(name, breaking: breaking) do |lines|
        lines.collect! { |l| l.force_encoding(Encoding::Shift_JIS).encode!(Encoding::UTF_8) }
      end
    end

  end
end
