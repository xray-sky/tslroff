# encoding: UTF-8
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

class Inferno::FourthEd
  class Troff << ::Inferno::Troff

    alias :LP :P

    def initialize(source)
      case @source.file
      when 'INDEX' then raise ManualIsBlacklisted, 'is nonsense'
      end
      super(source)
    end

  end
end
