# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 05/25/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Data General DG/UX 4.31 Version Overrides
#
# TODO: cause missing 4.31 links to be rewritten into 4.30 (this is an incremental update package)
#

module DG_UX_4_31

  def self.extended(k)
    k.instance_variable_set '@heading_detection', %r(^\s{5}(?<section>[A-Z][A-Za-z\s]+)$)
  end

end


