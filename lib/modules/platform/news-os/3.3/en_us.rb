# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/31/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# NEWS-os 3.3 Platform Overrides
#
# TODO
#

class NEWS_os::V3_3_en_US
  class Troff < ::NEWS_os::Troff

    def source_init
      case @source.file
      when 'index.3' then @manual_entry = '_index'
      # TODO when we resolve the baseline/font issue with \u, \d, and \s
      # current status in un-messed-with state is, ugly but not broken.
      # tried to fix it and achieved broken.
      # also there's the issue of doing rewrites in .so for gamma.3m
      #when 'lgamma.3m'
      #  k.instance_variable_get('@source').lines[26].gsub!(/\\s10/, "\\s12")
      end
      super
    end

    def init_ds
      super
      @state[:named_string].merge!(
        {
          footer: "NEWS-OS\t\\s-2Release 3.3\\s+2",
          ']D' => "UNIX Programmer's Manual",
          ']W' => "7th Edition"
        }
      )
    end

  end
end
