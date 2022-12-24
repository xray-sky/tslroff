# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 09/04/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Kodak Interactive UNIX v2.2 Platform Overrides
#
# TODO
#   disk(7) - overstruck 'SEE ALSO'
#

module Interactive_2_2

  def self.extended(k)
    k.instance_variable_set '@manual_entry',
      k.instance_variable_get('@input_filename').sub(/\.(\d\S?)(?:\.z)?$/, '')
    k.instance_variable_set '@heading_detection', %r(^\s{10}(?<section>[A-Z][A-Za-z\s]+)$)
    # some of these entries with longish names end up with clashes in the title line
    # so detect just on closing parenthesis, regardless of following whitespace
    # - this seems sufficient for 4.52 & RW4.00. Also the case in 5.01.
    k.instance_variable_set '@title_detection', %r{^\s{10}(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)(?:-(?<systype>\S+?))?\))}
    case k.instance_variable_get '@input_filename'
    when /\.cpio$/
      raise ManualIsBlacklisted, 'is cpio install pkg'
    end
  end

end
