# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2014 Typewritten Software. All rights reserved.
#
# Atari SysV Platform Overrides
#
# TODO
# √ 1.1-06 xterm.1 and a lot of ue12 has base indent of only 2
#   ue12 cc(1) detects title line in SEE ALSO
#

module Atari_SysV
  class Nroff < Nroff

    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.(\d\S?)$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      @heading_detection ||= %r{^\s{2,3}(?<section>[A-Z][A-Za-z\s]+)$}
      @title_detection ||= %r{^\s{2,3}(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))} # REVIEW now what?
      @lines_per_page ||= 67
      super(source, **kwargs)
    end

  end
end
