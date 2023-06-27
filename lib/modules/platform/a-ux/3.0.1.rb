# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/28/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Apple A/UX 3.0.1 Version Overrides
#

module A_UX_3_0_1

  def self.extended(k)
    k.instance_variable_set '@manual_entry', k.instance_variable_get('@input_filename').sub(/\.(?<section>\d\S*?)(?:\.[zZ])?$/, '')
    k.instance_variable_set '@heading_detection', %r(^(?<section>[A-Z][A-Za-z\s]+)$)
    k.instance_variable_set '@title_detection', %r{^(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))\s.+?\s\k<manentry>$}
    case k.instance_variable_get '@input_filename'
    when 'appres.1.Z'
      k.instance_variable_set '@heading_detection', %r(^\s{5}(?<section>[A-Z][A-Za-z\s]+)$)
      k.instance_variable_set '@title_detection', %r{^\s{5}(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))\s.+?\s\k<manentry>$}
    when 'XtCreateApplicationContext.3xt.Z', 'XtDestroyApplicationContext.3xt.Z',
         'XtToolkitInitialize.3xt.Z', 'XtWidgetToApplicationContext.3xt.Z'
      k.instance_variable_set '@title_detection', %r{^\s+(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))\s+$}
    when 'Autologin.4.Z'
      raise ManualIsBlacklisted, 'is tar file' # TODO (later)
    end
  end

end


