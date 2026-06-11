# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/04/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# 4.1BSD Platform Overrides (tmac.an.new)
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

    def self.name_for_section(sec)
      BSD.name_for_section(sec)
    end

  end
end
