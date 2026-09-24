# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Ultrix 1.1 Platform Overrides
#
# TODO
#

module Ultrix
  module V1_1_0

    class Troff < Troff
      def init_ds
        super
        @named_strings.merge!(
          {
            ']D' => 'UNIX Programmer\'s Manual',
            ']W' => '7th Edition',
            :footer => '' # just a page number
          }
        )
      end

      def TH(*args)
        heading = "#{args[0]}\\|(\\|#{args[1]}\\|)" # tmac.an uses \f(TB
        super(*args, heading: heading)
      end
    end

    def self.name_for_section(sec)
      case sec.downcase
      when '1x' then "<strong>#{sec}.</strong> X10 Commands"
      else Ultrix.name_for_section(sec)
      end
    end

  end
end
