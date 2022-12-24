# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 09/10/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Inferno 4e Platform Overrides
#
# TODO
#   can't find the macros - .EE, .EX, .L, .LR, .RL, .TF, font position 5
#   .L* is probably font 'L'; might also be font pos 5
#

module Inferno_4ed

  def self.extended(k)
    k.define_singleton_method(:LP, k.method(:PP)) if k.methods.include?(:PP)
    case k.instance_variable_get '@input_filename'
    when 'INDEX'
      raise ManualIsBlacklisted, 'is nonsense'
    end
  end

end
