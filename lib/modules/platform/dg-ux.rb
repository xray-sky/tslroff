# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/24/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Data General DG/UX Platform Overrides
#
# Some of the page titles don't match the pattern "man(sec)   something   man(sec)"
#                                 but instead are "something              man(sec)"
#        and a couple with super long names match "maaaaaaaaaaan(smaaaaaaaaan(sec)"
# - but with backspaces are they looking ok? perhaps not or I'd get type clashes?
#
# (5.4.2) still linking header line when see also spans page breaks
#
# REVIEW how did I end up with a bunch of zero length .z files in 5.4R3.00 ?
#

module DG_UX
  class Source < Source
    def initialize(file, **kwargs, &block)
      kwargs[:encoding] ||= Encoding::ISO_8859_1
      super(file, **kwargs, &block)
    end
  end

  class Nroff < Nroff
    def initialize(source)
      @manual_entry ||= source.file.sub(/\.(?:\d\S?)\.g?[zZ]$/, '')
      @heading_detection ||= %r(^(?<section>[A-Z][A-Za-z\s]+)$)
      @title_detection ||= %r{\s(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))$}
      super(source)
    end
  end
end


