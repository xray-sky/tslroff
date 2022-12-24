# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 09/05/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# SCO OpenDesktop 1.1.1g Platform Overrides
#

module OpenDesktop_1_1_1g

  def self.extended(k)
    k.instance_variable_set '@heading_detection', %r(^\s{4,5}(?<section>[A-Z][A-Za-z\s]+)$)
    k.instance_variable_set '@title_detection', %r{^\s{5}(?<manentry>(?<cmd>\S+?)\((?<section>[A-Z]+)\))\s+}
    k.instance_variable_set '@related_info_heading', 'See Also'
    case k.instance_variable_get '@input_filename'
    when 'bdftosnf.X.z', 'ico.X.z', 'mkfontdir.X.z', 'oclock.X.z', 'showsnf.X.z',
         'xdpyinfo.X.z', 'xev.X.z', 'xeyes.X.z', 'xmodmap.X.z', 'xset.X.z', 'xwininfo.X.z'
      k.instance_variable_set '@title_detection', %r{^\s{4}(?<manentry>(?<cmd>\S+?)\s\((?<section>[A-Z]+)\))\s+}
      k.instance_variable_set '@related_info_heading', 'SEE ALSO'
    end
  end

end


