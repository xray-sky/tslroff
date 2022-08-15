# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/12/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# NEWS-os 4.2.1R (SJIS) Platform Overrides
#
# TODO
# √ <html lang="ja">
# √ all the 'alias' pages (the ones which just .so another page) aren't Shift_JIS and break on re-encoding
#   tbl(1) has postprocessed tbl - looks like map3270(5) does too
# √ eqn(1) getting rogue <br>  leaving eqn text... sometimes? is this the same as noticing extra <br> in solaris?
# √ ntpq(1) misidentified as nroff source
#   checknr(1) :: [47] has \f& (probably meant \&) - doesn't need fixing, just turn of the red css
#   dbx(1) :: [537] tries to use \f4
#   learn(1) :: [121] \f (nothing)
#   listres(1) :: [39, 41] \f-, \fi, \fp
# √ jctype(3j) :: has postprocessed tbl (sigh) -- just need \l, tbl(1) is worse
# √ XArc(3X11) :: appears to have an eqn split across two input lines?  (skewed-angle... etc)
#
#   mh-chart(n) :: needs /usr/new/lib/mh/tmac.h -- also \b bracket drawing
#

module NEWS_os_4_2_1R_ja_JP

  def self.extended(k)
    k.instance_variable_set '@language', 'ja'
    k.instance_variable_get('@source').lines.collect! { |k| k.force_encoding(Encoding::Shift_JIS).encode!(Encoding::UTF_8) }
    k.instance_variable_set '@related_info_heading', %r{関連事項}u
    case k.instance_variable_get '@input_filename'
    when 'index.3', 'index.3f7768'
      k.instance_variable_set '@manual_entry', '_index'
    # TODO when we resolve the baseline/font issue with \u, \d, and \s
    # current status in un-messed-with state is, ugly but not broken. tried to fix it and achieved broken.
    # also there's the issue of doing rewrites in .so for gamma.3m
    #when 'lgamma.3m'
    #  k.instance_variable_get('@source').lines[26].gsub!(/\\s10/, "\\s12")
    when 'ntpq.8'
      # incorrectly recognized as nroff source as the first character is '@'
      k.instance_variable_get('@source').lines[0].sub!(/^/, '.')
      require_relative '../../../dom/troff.rb'
      # save a ref to our :init_ds and :req_TH methods, before they get smashed by the extend
      # processing doesn't require .so, .AT, etc., so they don't need saving
      k.define_singleton_method :_init_ds, k.method(:init_ds)
      k.define_singleton_method :_req_TH, k.method(:req_TH)
      k.extend ::Troff
      k.define_singleton_method :init_ds, k.method(:_init_ds)
      k.define_singleton_method :req_TH, k.method(:_req_TH)
    end
  end

  def init_ds
    super
    @state[:named_string].merge!({
      ']D' => "NEWS-OS Programmer's Manual",
      ']W' => "7th Edition"
    })
  end

  def req_so(name)
    super(name) { |lines| lines.collect! { |k| k.force_encoding(Encoding::Shift_JIS).encode!(Encoding::UTF_8) } }
  end

  # doesn't matter, ]W not used in header or footer
  def req_AT(*args)
    req_ds ']W', case args[0]
                 when '3' then '7th Edition'
                 when '4' then 'System III'
                 when '5'
                   if args[1] and !args[1].empty?
                     "System V Release #{args[1]}"
                   else
                     'System V'
                   end
                 else '7th Edition'
                 end
  end

  def req_TH(*args)
    unescape "NEWS-OS\t\\s-2Release 4.2.1R\\s+2", output: @state[:footer]
    heading = "#{args[0]}\\^(\\^#{args[1]}\\^)"
    req_ds(']L', args[2])
    req_ds(']W', args[3]) if args[3] and !args[3].empty?
    req_ds(']D', args[4]) if args[4] and !args[4].empty?
    heading << '\\0\\0\\(em\\0\\0\\*(]D'
    super(*args, heading: heading)
  end

  # doesn't matter, ]W not used in header or footer
  def req_UC(*args)
    req_ds ']W', case args[0]
                 when '3' then '3rd Berkeley Distribution'
                 when '4' then '4th Berkeley Distribution'
                 when '5' then '4.2 Berkeley Distribution'
                 when '6' then '4.3 Berkeley Distribution'
                 else '3rd Berkeley Distribution'
                 end
  end
end


