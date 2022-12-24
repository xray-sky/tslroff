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

require_relative './en_us.rb'

module NEWS_os_3_3_ja_JP

  def self.extended(k)
    k.extend NEWS_os_3_3_en_US
    k.instance_variable_set '@language', 'ja'
    k.instance_variable_get('@source').lines.collect! { |k| k.force_encoding(Encoding::Shift_JIS).encode!(Encoding::UTF_8) }
    k.instance_variable_set '@related_info_heading', %r{関連事項}u
    case k.instance_variable_get '@input_filename'
    when 'index.3'
      k.instance_variable_set '@manual_entry', '_index'
    # TODO when we resolve the baseline/font issue with \u, \d, and \s
    # current status in un-messed-with state is, ugly but not broken. tried to fix it and achieved broken.
    # also there's the issue of doing rewrites in .so for gamma.3m
    #when 'lgamma.3m'
    #  k.instance_variable_get('@source').lines[26].gsub!(/\\s10/, "\\s12")
    end
  end

  def req_so(name, breaking: nil)
    super(name) { |lines| lines.collect! { |k| k.force_encoding(Encoding::Shift_JIS).encode!(Encoding::UTF_8) } }
  end

end


