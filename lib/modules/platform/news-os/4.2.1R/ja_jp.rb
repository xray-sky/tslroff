# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/12/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# NEWS-os 4.2.1R (SJIS) Platform Overrides
#
# TODO pic - libfcvg(3x)
# TODO
# √ <html lang="ja">
# √ all the 'alias' pages (the ones which just .so another page) aren't Shift_JIS and break on re-encoding
#   tbl(1) has postprocessed tbl - looks like map3270(5) does too
# √ eqn(1) getting rogue <br>  leaving eqn text... sometimes? is this the same as noticing extra <br> in solaris?
# √ ntpq(1) misidentified as nroff source
#   checknr(1) :: [47] has \f& (probably meant \&) - doesn't need fixing, just turn off the red css
#   dbx(1) :: [537] tries to use \f4
#   learn(1) :: [121] \f (nothing)
#   listres(1) :: [39, 41] \f-, \fi, \fp
# √ jctype(3j) :: has postprocessed tbl (sigh) -- just need \l, tbl(1) is worse
# √ XArc(3X11) :: appears to have an eqn split across two input lines?  (skewed-angle... etc)
# √ ypwhich(8) :: use of refer -- .[  .]
#                 not actually. looks like mistake in synopsis section
#
#   mh-chart(n) :: needs /usr/new/lib/mh/tmac.h -- also \b bracket drawing
#

require_relative './en_us'

class NEWS_os::V4_2_1R_ja_JP

  class Manual < Manual
    def initialize(file, vendor_class: nil, source_args: nil)
      @language ||= 'ja'
      srcargs = source_args.dup || {}
      srcargs[:encoding] ||= Encoding::Shift_JIS
      case File.basename(file)
      when 'ntpq.8' then srcargs[:magic] = 'Troff'
      end
      super(file, vendor_class: vendor_class, source_args: srcargs)
    end
  end

  class Troff < NEWS_os::V4_2_1R_en_US::Troff

    def initialize(source)
      @related_info_heading ||= %r{関連事項}u
      case source.file
      # TODO when we resolve the baseline/font issue with \u, \d, and \s
      # current status in un-messed-with state is, ugly but not broken. tried to fix it and achieved broken.
      # also there's the issue of doing rewrites in .so for gamma.3m
      #when 'lgamma.3m' then source.lines[26].gsub!(/\\s10/, "\\s12")
      # incorrectly recognized as nroff source as the first character is '@'
      when 'ntpq.8' then source.patch_line(1, /^/, '.')
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
