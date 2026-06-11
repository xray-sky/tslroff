# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/04/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# 4.3BSD-VAX-MIT Platform Overrides (tmac.an.new)
#
# TODO
#

module BSD
  module V4_3

    class Troff < Troff
      # tmac.an.new
      def UC(v = nil, *_args)
        ds(']W ' + case v
                   when '4' then '4th Berkeley Distribution'
                   when '5' then '4.2 Berkeley Distribution'
                   when '6' then '4.3 Berkeley Distribution'
                   else '3rd Berkeley Distribution'
                   end
          )
      end
    end

    def self.name_for_section(sec)
      BSD.name_for_section(sec)
    end

  end
end
