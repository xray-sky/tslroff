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

class Ardent_SysV::R4_2
  class Manual < Manual
    def initialize(file, vendor_class: nil, source_args: {})
      case File.basename(file)
      when 'p162.7'    then source_args[:magic] = 'Troff'
      when 'tdore.sid' then raise ManualIsBlacklisted, 'is metadata'
      end

      super file, vendor_class: vendor_class, source_args: source_args

      case File.basename(file)
      when 'p162.7' then @source.patch_line(1, /^/, '.')
      end
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

