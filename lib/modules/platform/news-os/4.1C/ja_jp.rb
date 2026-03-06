# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/31/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# NEWS-os 4.1C (SJIS) Platform Overrides
#
# TODO
# √ mwm(1) :: [80] infinite loop?!
#                  groff: <standard input>:1: `\-' is not allowed in an escape name
#                  troff seems to ignore it, take the next char ("foo\n\-bar" prints "foo0ar")
#

require_relative './en_us'

class NEWS_os::V4_1C_ja_JP

  class Manual < ::Manual
    def initialize(file, vendor_class: nil, source_args: {})
      case File.basename(file)
      when 'ntpq.8' then @source = Source.new(file, magic: 'Troff', source_args: source_args)
      end
      super(file, vendor_class: vendor_class, source_args: source_args)
    end
  end

  class Troff < ::NEWS_os::V4_1C_en_US::Troff
    def initialize(source)
      @language ||= 'ja'
      source.lines.collect! { |l| l.force_encoding(Encoding::Shift_JIS).encode!(Encoding::UTF_8) }
      @related_info_heading ||= %r{関連事項}u
      super(source)
    end

    def source_init
      case @source.file
      when 'index.3', 'index.3f'
        @manual_entry = '_index'
      # TODO when we resolve the baseline/font issue with \u, \d, and \s
      # current status in un-messed-with state is, ugly but not broken. tried to fix it and achieved broken.
      # also there's the issue of doing rewrites in .so for gamma.3m
      #when 'lgamma.3m'
      #  k.instance_variable_get('@source').lines[26].gsub!(/\\s10/, "\\s12")
      when 'mwm.1' # TODO actually fix the code so that \n\- doesn't result in infinite loop. but the output would still be wrong...
        @source.patch_line(80, /\\n/, '')
      when 'ntpq.8'
        # incorrectly recognized as nroff source as the first character is '@'
        @source.patch_line(1, /^/, '.')
      end
      super
    end

    def so(name, breaking: nil)
      super(name, breaking: breaking) do |lines|
        lines.collect! { |l| l.force_encoding(Encoding::Shift_JIS).encode!(Encoding::UTF_8) }
      end
    end

  end
end
