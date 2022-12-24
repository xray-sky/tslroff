# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 09/05/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Data General DG/UX R4.11 Version Overrides
#

module DG_UX_R4_11

  def self.extended(k)
    k.instance_variable_get('@source').lines.collect! { |k| k.force_encoding(Encoding::ISO_8859_1).encode!(Encoding::UTF_8) }
    k.instance_variable_set '@lines_per_page', nil
    case k.instance_variable_get '@input_filename'
    when /^(?:contents|index)\d?\.(?:B2|C2|dgux|failover|nfs|onc|sdk|tcpip|X11)/
      raise ManualIsBlacklisted, 'is metadata'
    end
  end

end


