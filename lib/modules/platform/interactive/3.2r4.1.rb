# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/04/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# SunSoft Interactive UNIX v3.2r4.1 Platform Overrides
#
# TODO
# √ constantly shrinking \s? e.g. Xcpqag(1)
# √ explicit .ps 10 after .TE is "interfering" with our default size of 12 on \s-1::\s+1 e.g. Xwge(1)
#    -- should maybe put a nuclear strategy in }f or .SS/.SH or wherever, so :prev_ps doesn't drift
#   Xvga(1), Xv256(1) :: tbl missing cell borders on spanned "resolution" rows
#   ksh(1) :: wtf
#

class Source
  def magic
    case File.basename(@filename)
    when 'i596.7' then 'Troff'
    else @magic
    end
  end
end

module Interactive_3_2r4_1

  def self.extended(k)
    case k.instance_variable_get '@input_filename'
    when 'file'
      raise ManualIsBlacklisted, 'is shell script'
    when /intro\.nfs\.(\d)/ # easier to just override these than mess with the regex
      k.instance_variable_set '@manual_entry', 'intro.nfs'
      k.instance_variable_set '@manual_section', Regexp.last_match[1]
    when 'i596.7'
      # misidentified as nroff
      k.instance_variable_get('@source').lines[0].insert(0, '.\\"')
    end
  end

end
