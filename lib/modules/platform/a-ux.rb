# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 05/28/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Apple A/UX Platform Overrides
#
# 0.7 postscript(7), pscatmap(8), transcript(8), etc. is troff source
# 2.0 some pages got sections in their names - autorecovery.8.html, etc.
#     - these do not end with .z - this is fixed now but leaving the note to think harder about being more generic
# 2.0 esch(8) sees-also "Startup-^MShell(8)" (with line break)
#

module A_UX

  def self.extended(k)
    k.instance_variable_set '@manual_entry',
      k.instance_variable_get('@input_filename').sub(/\.(?:\d\S?)(?:\.[zZ])?$/, '') # REVIEW: would this be better & more generic as a 'scan' call? everything after the section?
    k.instance_variable_set '@heading_detection', %r(^\s{5}(?<section>[A-Z][A-Za-z\s]+)$)
    k.instance_variable_set '@title_detection', %r{^\s{5}(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))\s.+?\s\k<manentry>$}
  end

  def page_title
    "#{@manual_entry}(#{@manual_section}) &mdash; A/UX #{@version}"
  end
end


