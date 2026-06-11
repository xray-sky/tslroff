# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/27/23.
# Copyright 2023 Typewritten Software. All rights reserved.
#
#
# Ardent SysV 4.2 Platform Overrides
#
# TODO
#   check macros (where are they?)
#   pic - xmon(1) [4.2]
#

module Ardent_SysV
  module R4_2

    class Source < Source
      def initialize(file, **kwargs, &block)
        case File.basename(file)
        when 'p162.7'    then kwargs[:magic] = 'Troff'
        when 'tdore.sid' then raise ManualIsBlacklisted, 'is metadata'
        end

        super(file, **kwargs, &block)

        case @file
        when 'p162.7' then patch_line(1, /^/, '.')
        end
      end
    end

    class Troff < Troff
      def init_ds
        super
        @named_strings.merge!(
          {
            'Tt' => 'Titan 1500/3000',
            ']D' => 'Kubota Pacfic Computer Inc.'
          }
        )
      end
    end

    def self.name_for_section(sec)
      Ardent_SysV.name_for_section(sec)
    end

  end
end
