# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 05/25/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Data General DG/UX 4.30 Version Overrides
#

module DG_UX_4_30

  def self.extended(k)
    k.instance_variable_set '@heading_detection', %r(^\s{5}(?<section>[A-Z][A-Za-z\s]+)$)
  end

end


