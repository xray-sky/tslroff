# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 05/31/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# Domain/OS SR9.5 Platform Overrides
#
# TODO:
#

module DomainOS_SR9_5

  def self.extended(k)
    k.instance_variable_set '@lines_per_page', 66	# REVIEW: at least for /IX
    case k.instance_variable_get '@input_filename'
    when 'index.hlp'
      k.instance_variable_set '@manual_entry', '_index'
    when 'edacl.hlp'
      k.instance_variable_set '@heading_detection', %r{^(?<section>[A-Z][A-Za-z0-9\s]+)$}
      k.instance_variable_set '@related_info_heading', 'RELATED TOPICS'
    when 'root.3m'
      raise ManualIsBlacklisted, 'not a manual entry'
    end
  end

  def page_title
    super << " Domain/IX SR9.5"
  end

end
