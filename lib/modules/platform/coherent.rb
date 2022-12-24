# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 09/05/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# MWC Coherent Platform Overrides
#
#  these are all nroff without the normal unix online manual
#  structures around them
#
# TODO
#   linkify sectionless refs. some with, some without '()'
#

module Coherent

  def self.extended(k)
    k.instance_variable_set '@heading_detection', %r(^\s{5}(?<section>[A-Z][A-Za-z\s]+)$)
    k.instance_variable_set '@title_detection', %r{^\s{5}(?<manentry>(?<cmd>\S+?)\(\S*?\))\s.+?\s\k<manentry>$}
    k.instance_variable_set '@output_directory',
      File.basename(k.instance_variable_get '@source_dir')
    k.instance_variable_set '@related_info_heading', '***** See Also *****'
    case k.instance_variable_get '@input_filename'
    when 'default'
      k.instance_variable_set '@manual_entry', '_default'
    when 'index'
      k.instance_variable_set '@manual_entry', '_index'
    when /^_(23|5F)/
      trname = k.instance_variable_get('@manual_entry').slice(1..-1)
      trname.gsub!(/5F5F/, '__')
      trname.gsub!(/23/, '#')
      k.instance_variable_set '@manual_entry', trname
    end
  end

end

