# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 07/20/26.
# Copyright 2026 Typewritten Software. All rights reserved.
#
#
# HP-UX 7.01 Platform Overrides
#
# TODO
#

module HPUX
  module V7_01

    class Troff < Troff

      def init_ds
        super
        @named_strings.merge!(
          {
            # uses )H but this is defined directly in }F so I don't see how it could ever not be HP Co.
            footer: "Hewlett-Packard Company\\0\\0\\(em\\0\\0\\*(]W".+@,
            'Tm' => '&trade;',
            # REVIEW is this what actually goes in the footer in the printed manual?
            ']V' => File.mtime(@source.path).strftime("%B %d, %Y")
          }
        )
      end

      def TH(*args)
        ds "]L #{args[3]}"
        as "]L \" \\|(\\^#{args[2]}\\^)" if args[2] and !args[2].strip.empty? # attend: append ]L
        ds "]W #{send '__unesc_*', '\\*(]V'}"

        unless @named_strings[']D'].empty?
          byline = Block::Footer.new
          byline.style.css[:margin_top] = '0.5em' # TODO not working? getting 4em from css
          unescape "\\f3\\*(]D\\fP", output: byline
          @document << byline
        end

        heading = "#{args[0]}\\^(\\^#{args[1]}\\^)".+@
        heading << '\\0\\0\\(em\\0\\0\\*(]L' unless @named_strings[']L'].empty?

        super(*args, heading: heading)
      end

    end

    def self.name_for_section(sec)
      HPUX.name_for_section(sec)
    end

  end
end
