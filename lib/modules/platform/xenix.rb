# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 06/23/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# SCO OpenDesktop Platform Overrides
#

module Xenix

  def self.extended(k)
    #k.instance_variable_set '@manual_entry',
    #  k.instance_variable_get('@input_filename').sub(/(?:_bsd|_.+fs|_s5|_xnx)?\.(?:[\dZz]\S?)$/, '')
    k.instance_variable_set '@heading_detection', %r(^\s{5}(?<section>[A-Z][A-Za-z\s]+)$)
    k.instance_variable_set '@title_detection', %r{^\s+(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))\s.+?\s\k<manentry>$}
    k.instance_variable_set '@related_info_heading', 'See Also'
  end

  def parse_title
    title = get_title or warn "reached end of document without finding title!"
    return unless title
    @manual_entry     = title[:cmd].downcase
    @manual_section   = title[:section]
    @output_directory = "man#{@manual_section}"
    title
  end

  # SCO uses alphabetic section names
  def detect_links(line)
    # make sure we break detection on space or punctuation, in order to correctly
    line.scan(/(?<=[\s,.;])((\S+?)\(([A-Z]+?)\))/).map do |text, ref, section|
      [text, "../man#{section}/#{ref}.html"]
    end.to_h
  end
end


