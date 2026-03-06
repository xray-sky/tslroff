# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/10/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# Intergraph CLIX Platform Overrides
#

class CLIX
  class Nroff < ::Nroff

    def initialize(source)
      @manual_entry ||= source.file.sub(/\.([\dZz]\S*?)$/, '')
      @heading_detection ||= %r(^\s{2}(?<section>[A-Z][A-Za-z\s]+)$)
      @title_detection ||= %r{^\s{2}(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))\s.+?\s\k<manentry>$}
      @related_info_heading ||= 'RELATED INFORMATION'
      super(source)
    end

  end
end


