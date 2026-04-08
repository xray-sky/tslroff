# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/04/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Bell UNIX V7 Platform Overrides
#
# TODO
#

module UNIX
  module V7
    class Troff < Troff
      def init_ds
        super
        @named_strings.merge!(
          {
            ']D' => "UNIX Programmer's Manual",
            ']W' => "7th Edition",
            :footer => "\\*(]W"
          }
        )
      end

      def TH(*args)
        ds "]L #{args[2]}"

        heading = "#{args[0]}\\|(\\|#{args[1]}\\|)\\0\\0\\(em\\0\\0\\*(]D"
        @named_strings[:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @named_strings[']L'].empty?

        super(*args, heading: heading)
      end
    end
  end
end
