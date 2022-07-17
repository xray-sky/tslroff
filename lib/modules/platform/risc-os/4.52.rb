# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 06/03/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# mips RISC/os 4.52 Platform Overrides
#
# TODO:
#

module RISC_os_4_52

  def self.extended(k)
    case k.instance_variable_get '@input_filename'
    when /1prom$/
      k.instance_variable_set '@manual_entry',
        k.instance_variable_get('@input_filename').sub(/\.1prom$/, '')
      k.instance_variable_set '@heading_detection', %r{^\s{5}(?<section>[A-Z][A-Za-z0-9\s]+)$}
      k.instance_variable_set '@title_detection', %r{^\s{5}(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)(?:-(?<systype>\S+?))?\))\s.+?\s\k<manentry>$}
    when 'newsetup.1', 'newsgroups.1', 'patch.1', 'Pnews.1', 'Rnmail.1'
      # have section as 'entry(1 LOCAL)'
      k.instance_variable_set '@title_detection', %r{^(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)(?:\s(?<systype>\S+?))?\))}
    end
  end

  def page_title
    super.sub(/\S+$/, 'UMIPS RISC/os 4.52')
  end

end
