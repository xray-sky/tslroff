# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/05/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Ardent SysV 4.1 Platform Overrides
#
# TODO pic - xmon(1) [4.2]
# TODO
#

module Ardent_SysV_R4_1

  def self.extended(k)
    case k.instance_variable_get '@input_filename'
    when 'tdore.sid'
      raise ManualIsBlacklisted, 'is metadata'
    end
  end

  def init_ds
    super
    @state[:named_string].merge!(
      {
        'Tt' => 'Titan 1500/3000',
        ']D' => 'Kubota Pacfic Computer Inc.'
      }
    )
  end

end

