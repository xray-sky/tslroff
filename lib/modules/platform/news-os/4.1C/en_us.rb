# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/31/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# NEWS-os 4.1C Platform Overrides
#
# TODO
#

module NEWS_os_4_1C_en_US

  def self.extended(k)
    case k.instance_variable_get '@input_filename'
    when 'index.3', 'index.3f'
      k.instance_variable_set '@manual_entry', '_index'
    # TODO when we resolve the baseline/font issue with \u, \d, and \s
    # current status in un-messed-with state is, ugly but not broken. tried to fix it and achieved broken.
    # also there's the issue of doing rewrites in .so for gamma.3m
    #when 'lgamma.3m'
    #  k.instance_variable_get('@source').lines[26].gsub!(/\\s10/, "\\s12")
    end
  end

  def init_ds
    super
    @state[:named_string].merge!({
      ']D' => "NEWS-OS Programmer's Manual",
      ']W' => "7th Edition",
      :footer => "NEWS-OS\t\\s-2Release 4.1C\\s+2"
    })
  end

end


