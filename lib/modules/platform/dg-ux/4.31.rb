# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/25/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Data General DG/UX 4.31 Version Overrides
#
# TODO: cause missing 4.31 links to be rewritten into 4.30 (this is an incremental update package)
#

class DG_UX::V4_31
  class Nroff < DG_UX::Nroff

    def initialize(source)
      @heading_detection ||= %r(^\s{5}(?<section>[A-Z][A-Za-z\s]+)$)
      super(source)
    end

  end
end


