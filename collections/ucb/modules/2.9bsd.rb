# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/06/23.
# Copyright 2023 Typewritten Software. All rights reserved.
#
#
# 2.9BSD Platform Overrides (tmac.an.new) - same as 4.3_VAX_MIT except fewer cases in .UC
#
# TODO
#

module BSD
  # TODO (maybe) - no AT, DE, DS in 2.9
  module V2_9
    class Troff < Troff

      # TODO this appears in other versions' macros too
      def init_ds
        super
        @named_strings.merge!(
          {
            'R' => '\\(rg'
          }
        )
      end

      def UC(v = nil, *_args)
        ds(']W ' + case v
                   when '2' then 'Second Berkeley Distribution'
                   when '4' then '4th Berkeley Distribution'
                   else "#{args[1]} #{args[0]} BSD"
                   end
          )
      end
    end

    def self.name_for_section(sec)
      BSD.name_for_section(sec)
    end

  end
end
