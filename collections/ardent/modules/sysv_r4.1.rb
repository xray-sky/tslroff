# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/05/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Ardent SysV 4.1 Platform Overrides
#
# TODO
#

module Ardent_SysV
  module R4_1

    class Source < Source
      def initialize(file, **kwargs, &block)
        case File.basename(file)
        when 'tdore.sid' then raise ManualIsBlacklisted, 'is metadata'
        end
        super(file, **kwargs, &block)
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
