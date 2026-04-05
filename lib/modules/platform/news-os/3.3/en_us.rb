# frozen_string_literal: true
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

module NEWS_os
  module V3_3_en_US
    class Troff < Troff

      def init_ds
        super
        @named_strings.merge!(
          {
            footer: "NEWS-OS\t\\s-2Release 3.3\\s+2".+@,
            ']D' => "UNIX Programmer's Manual",
            ']W' => "7th Edition"
          }
        )
      end

    end
  end
end
