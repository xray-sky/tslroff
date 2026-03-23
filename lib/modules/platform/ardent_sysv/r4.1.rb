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

class Ardent_SysV::R4_1
  class Troff < ::Ardent_SysV::Troff

    def source_init
      case @source.file
      when 'tdore.sid' then raise ManualIsBlacklisted, 'is metadata'
      end
      super
    end

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
end

class Ardent_SysV::R4_2 < Ardent_SysV::R4_1 ; end
