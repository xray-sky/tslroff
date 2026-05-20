# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/10/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# Intergraph CLIX Platform Overrides
#

module CLIX
  class Nroff < Nroff

    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.([\dZz]\S*?)$/, '')
      @heading_detection ||= %r(^\s{2}(?<section>[A-Z][A-Za-z\s]+)$)
      @title_detection ||= %r{^\s{2}(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))\s.+?\s\k<manentry>$}
      @related_info_heading ||= 'RELATED INFORMATION'
      super(source, **kwargs)
    end

  end

  def self.name_for_section(sec)
    case sec.downcase
    when '0'  then "<strong>#{sec}.</strong> Header Files"
    when '1'  then "<strong>#{sec}.</strong> Commands"
    when '2'  then "<strong>#{sec}.</strong> System Calls"
    when '3'  then "<strong>#{sec}.</strong> Functions and Libraries"
    when '4'  then "<strong>#{sec}.</strong> File Formats"
    when '7'  then "<strong>#{sec}.</strong> Device Special Files"
    when '8'  then "<strong>#{sec}.</strong> Maintenance Commands"
    else "Section #{sec}"
    end
  end
end


