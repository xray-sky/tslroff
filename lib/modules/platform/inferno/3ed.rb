# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/09/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Inferno 3e Platform Overrides
#
# TODO
#   can't find the macros - .EE, .EX, .L, .LR, .RL, .TF, font position 5
#   .L* is probably font 'L'; might also be font pos 5
#

class Inferno::ThirdEd
  class Manual < Manual
    def initialize(file, vendor_class: nil, source_args: {})
      case File.basename(file)
      when 'INDEX' then raise ManualIsBlacklisted, 'is nonsense'
      end
      super file, vendor_class: vendor_class, source_args: source_args
    end
  end

  class Nroff < Inferno::Nroff ; end
  class Troff < Inferno::Troff ; end
end
