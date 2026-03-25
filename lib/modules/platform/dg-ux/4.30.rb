# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/25/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Data General DG/UX 4.30 Version Overrides
#

class DG_UX::V4_30
  class Nroff < DG_UX::Nroff

    def initialize(source)
      @heading_detection ||= %r(^\s{5}(?<section>[A-Z][A-Za-z\s]+)$)
      super(source)
    end

  end
end


