# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/04/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# BSD 4.3-VAX-MIT Platform Overrides (tmac.an.new)
#
# TODO
#

module BSD
  module V4_1
    class Troff < Troff
      # TODO this appears in other versions' macros too
      def init_ds
        super
        @named_strings.merge!(
          {
            'R'  => '\\(rg',
            'rq' => "''",
            'lq' => '``'
          }
        )
      end

      # REVIEW does this appear in other versions' macros too?
      def init_tr
        super
        @character_translations.merge!(
          {
            '*' => '\\(**'
          }
        )
      end

      # tmac.an.new
      def UC(v = nil, *args)
        ds(']W ' + case v
                   when '', nil then '3rd Berkeley Distribution'
                   else "#{args[0]}th Berkeley Distribution"
                   end
          )
      end
    end
  end

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
  end
end
