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
  class Manual < Manual
    def initialize(file, vendor_class: nil, source_args: {})
      case File.basename(file)
      when 'tdore.sid' then raise ManualIsBlacklisted, 'is metadata'
      end

      super file, vendor_class: vendor_class, source_args: source_args
    end
  end

  class Troff < Ardent_SysV::Troff

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
