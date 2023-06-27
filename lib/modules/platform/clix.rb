# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/10/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# Intergraph CLIX Platform Overrides
#

module CLIX

  def self.extended(k)
    k.instance_variable_set '@manual_entry', k.instance_variable_get('@input_filename').sub(/\.([\dZz]\S*?)$/, '')
    k.instance_variable_set '@heading_detection', %r(^\s{2}(?<section>[A-Z][A-Za-z\s]+)$)
    k.instance_variable_set '@title_detection', %r{^\s{2}(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))\s.+?\s\k<manentry>$}
    k.instance_variable_set '@related_info_heading', 'RELATED INFORMATION'
  end

end


