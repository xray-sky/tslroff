# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 08/08/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# SGI GL2-W2.3 Platform Overrides
#

module GL2_W2_3

  def self.extended(k)
    case k.instance_variable_get '@input_filename'
    when 'trenter.1' # is nroff
      k.instance_variable_set '@heading_detection', %r{^\s{5}(?<section>[A-Z][A-Za-z0-9\s]+)$}
      k.instance_variable_set '@title_detection',  %r{^\s{5}(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))}
    when 'regexp.5'
      k.instance_variable_get('@source').lines[418].sub!(/^\.in/, '.if')
    end
  end

end
