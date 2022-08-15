# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 06/07/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Intergraph CLIX 3.1r7.6.22 Platform Overrides
#

module CLIX_3_1r7_6_22

  def self.extended(k)
    case k.instance_variable_get '@input_filename'
    when 'index.3'
      k.instance_variable_set '@manual_entry', '_index'
    when 'convert.Z'
      raise ManualIsBlacklisted, 'apparently not a manual entry'
    end
  end

end


