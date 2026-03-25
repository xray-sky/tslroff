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

  class Manual < Manual
    def initialize(file, vendor_class: nil, source_args: nil)
      @language ||= 'ja'
      srcargs = source_args.dup || {}
      srcargs[:encoding] ||= Encoding::Shift_JIS
      case File.basename(file)
      when 'ntpq.8' then srcargs[:magic] = 'Troff'
      end
      super file, vendor_class: vendor_class, source_args: srcargs
    end
  end

  class Troff < NEWS_os::V4_1C_en_US::Troff
    def initialize(source)
      @related_info_heading ||= %r{関連事項}u
      case source.file
      # TODO when we resolve the baseline/font issue with \u, \d, and \s
      # current status in un-messed-with state is, ugly but not broken. tried to fix it and achieved broken.
      # also there's the issue of doing rewrites in .so for gamma.3m
      #when 'lgamma.3m'
      #  k.instance_variable_get('@source').lines[26].gsub!(/\\s10/, "\\s12")
      when 'mwm.1' # TODO actually fix the code so that \n\- doesn't result in infinite loop. but the output would still be wrong...
        source.patch_line(80, /\\n/, '')
      when 'ntpq.8'
        # incorrectly recognized as nroff source as the first character is '@'
        source.patch_line(1, /^/, '.')
      end
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
