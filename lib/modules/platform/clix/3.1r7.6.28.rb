# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 06/07/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Intergraph CLIX 3.1r7.6.28 Platform Overrides
#

module CLIX_3_1r7_6_28

  def self.extended(k)
    case k.instance_variable_get '@input_filename'
    when 'index.3'
      k.instance_variable_set '@manual_entry', '_index'
    when 'browse.1.Z', 'genmenu.1.Z', 'mrgpanel.1.Z' # REVIEW: should this be unbundled (IFORMS/S product)
      k.instance_variable_set '@heading_detection', %r(^\s{4}(?<section>[A-Z][A-Za-z\s]+)$)
      k.instance_variable_set '@title_detection', %r{^\s{4}(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))\s.+?\s\k<manentry>$}
     when 'convert.Z'
      raise ManualIsBlacklisted, 'apparently not a manual entry'
   end
  end

end


