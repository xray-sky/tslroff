# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/31/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# NEWS-os 5.0.1 Platform Overrides
#
# Yes, it actually does use the same macro file as SunOS 4.0.
# Just the definition of ]W changes (to not say SunOS)
# not sure ]W matters, as the troff pages are all X-related
# and I think have their own ]W via .TH
#
# TODO
#   ...-bsd pages (systype crib)
#    - there are some overlaps (e.g. cc(1), cc(1-bsd)) but the SEE ALSO links don't specify
#

require_relative '../sunos'
require_relative '../sunos/4.0'

module NEWS_os_5_0_1

  def self.extended(k)
    if k.instance_variable_get('@magic') == :Troff
      k.extend SunOS
      k.extend SunOS_4_0
    end
    k.instance_variable_set '@manual_entry', k.instance_variable_get('@input_filename').sub(/\.(\d\S?)$/, '')
    k.instance_variable_set '@manual_section', Regexp.last_match[1] if Regexp.last_match
    k.instance_variable_set '@heading_detection', %r{^(?<section>[A-Z][A-Za-z\s]+)$}
    k.instance_variable_set '@title_detection', %r{^(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))} # REVIEW now what?
  end

  def init_ds
    super
    @state[:named_string].merge!(
      {
        ']W' => File.mtime(@source.filename).strftime('%B %d, %Y'),
      }
    )
  end

end
