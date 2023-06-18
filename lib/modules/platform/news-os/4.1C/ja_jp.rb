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

require_relative './en_us.rb'

class Source
  def magic
    case File.basename(@filename)
    when 'ntpq.8' then 'Troff'
    else @magic
    end
  end
end

module NEWS_os_4_1C_ja_JP

  def self.extended(k)
    k.extend NEWS_os_4_1C_en_US
    k.instance_variable_set '@language', 'ja'
    k.instance_variable_get('@source').lines.collect! { |k| k.force_encoding(Encoding::Shift_JIS).encode!(Encoding::UTF_8) }
    k.instance_variable_set '@related_info_heading', %r{関連事項}u
    case k.instance_variable_get '@input_filename'
    when 'index.3', 'index.3f'
      k.instance_variable_set '@manual_entry', '_index'
    # TODO when we resolve the baseline/font issue with \u, \d, and \s
    # current status in un-messed-with state is, ugly but not broken. tried to fix it and achieved broken.
    # also there's the issue of doing rewrites in .so for gamma.3m
    #when 'lgamma.3m'
    #  k.instance_variable_get('@source').lines[26].gsub!(/\\s10/, "\\s12")
    when 'mwm.1' # TODO actually fix the code so that \n\- doesn't result in infinite loop. but the output would still be wrong...
      k.instance_variable_get('@source').lines[79].sub!(/\\n/, '')
    when 'ntpq.8'
      # incorrectly recognized as nroff source as the first character is '@'
      k.instance_variable_get('@source').lines[0].sub!(/^/, '.')
    end
  end

  def req_so(name, breaking: nil)
    super(name) { |lines| lines.collect! { |k| k.force_encoding(Encoding::Shift_JIS).encode!(Encoding::UTF_8) } }
  end

end


