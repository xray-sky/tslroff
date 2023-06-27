# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/23/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# Univel/Novell UnixWare Platform Overrides
#
# Odd pages margin is 7 spaces; even pages have 6
# Some entries include _bsd in the filename (sum.1, sum_bsd.1)
#   - we'll handle that with man1/ and man1bsd/
#   - also _xnx plus _bfs, _cdfs, _nucfs, etc.
#
# TODO: some pages use 'SEE ALSO' instead of 'REFERENCES'
#   - $ find man/ -type f -print | xargs grep SEE\ ALSO | wc -l
#           59
#

module UnixWare

  def self.extended(k)
    k.instance_variable_set '@manual_entry', k.instance_variable_get('@input_filename').sub(/(?:_bsd|_.+fs|_s5|_xnx)?\.(?:[\dZz]\S?)$/, '')
    k.instance_variable_set '@heading_detection', %r(^\s{6,7}(?<section>[A-Z][A-Za-z\s]+)$)
    k.instance_variable_set '@title_detection', %r{^       (?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))}
    k.instance_variable_set '@related_info_heading', 'REFERENCES'
  end

  def parse_title
    if @input_filename =~ /_to_.+\.3/
      @manual_section = '3BSD'
      @output_directory = 'man3bsd'
      ''
    else
      super
    end
  end
end


