# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/07/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Intergraph CLIX 3.1r7.6.22 Platform Overrides
#

class CLIX::V3_1r7_6_22
  class Nroff < CLIX::Nroff

    def initialize(source)
      case source.file
      when 'convert.Z' then raise ManualIsBlacklisted, 'apparently not a manual entry'
      end
      super(source)
    end

  end
end

