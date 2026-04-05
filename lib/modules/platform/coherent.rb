# frozen_string_literal: true
# encoding: UTF-8
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
  class Manual < Manual
    def output_directory
      @source.dir.split('/').last
    end
  end

  class Nroff < Nroff

    def initialize(source)
      @heading_detection ||= %r(^\s{5}(?<section>[A-Z][A-Za-z\s]+)$)
      @title_detection ||= %r{^\s{5}(?<manentry>(?<cmd>\S+?)\(\S*?\))\s.+?\s\k<manentry>$}
      @related_info_heading ||= '***** See Also *****'

      case source.file
      when /^_(23|5F)/
        trname = source.file.slice(1..-1)
        trname.gsub!(/5F5F/, '__')
        trname.gsub!(/23/, '#')
        @manual_entry = trname
      end

      super(source)
    end

  end
end
