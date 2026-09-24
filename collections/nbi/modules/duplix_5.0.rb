# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/05/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# ISI/NBI 4.3BSD (Duplix) Platform Overrides (tmac.an.new)
#
# TODO
#

module Duplix
  module V5_0
    class Troff < NBI_4_2BSD::Troff
      def init_ds
        super
        @named_strings.merge!(
          {
            ']W' => '\\f3INTEGRATED SOLUTIONS 4.3 BSD\\f1' # set by .}F
          }
        )
      end
    end

    def self.name_for_section(sec)
      case sec.downcase
      when '8c'    then "<strong>#{sec}.</strong> Communications Maintenance Commands"
      when '8i'    then "<strong>#{sec}.</strong> ISI-Specific Maintenance Commands"
      when '8v'    then "<strong>#{sec}.</strong> Maintenance Procedures"
      else
        NBI_4_2BSD.name_for_section(sec)
      end
    end
  end
end
