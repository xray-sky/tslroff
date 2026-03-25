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

class NEWS_os::V4_1C_en_US
  class Troff < NEWS_os::Troff

    def init_ds
      super
      @named_strings.merge!(
        {
          footer: "NEWS-OS\t\\s-2Release 4.1C\\s+2",
          ']D' => "NEWS-OS Programmer's Manual",
          ']W' => "7th Edition"
        }
      )
    end

  end
end

