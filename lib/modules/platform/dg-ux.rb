# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 05/24/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Data General DG/UX Platform Overrides
#
# Some of the page titles don't match the pattern "man(sec)   something   man(sec)"
#                                 but instead are "something              man(sec)"
#        and a couple with super long names match "maaaaaaaaaaan(smaaaaaaaaan(sec)"
# - but with backspaces are they looking ok? perhaps not or I'd get type clashes?
#
# REVIEW: how did I end up with a bunch of zero length .z files in 5.4R3.00 ?
#

module DG_UX

  def self.extended(k)
    k.instance_variable_set '@manual_entry',
      k.instance_variable_get('@input_filename').sub(/\.(\d\S?)\.g?[zZ]$/, '')
    k.instance_variable_set '@heading_detection', %r(^(?<section>[A-Z][A-Za-z\s]+)$)
    k.instance_variable_set '@title_detection', %r{\s(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))$}
  end

end


