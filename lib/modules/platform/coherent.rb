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

class Coherent
  class Nroff < ::Nroff

    def initialize(source)
      @heading_detection ||= %r(^\s{5}(?<section>[A-Z][A-Za-z\s]+)$)
      @title_detection ||= %r{^\s{5}(?<manentry>(?<cmd>\S+?)\(\S*?\))\s.+?\s\k<manentry>$}
      @output_directory ||= File.basename(k.instance_variable_get '@source_dir')
      @related_info_heading ||= '***** See Also *****'

      case source.file
      when 'default'
        @manual_entry ||= '_default'
      when 'index'
        @manual_entry ||= '_index'
      when /^_(23|5F)/
        trname = @manual_entry.slice(1..-1)
        trname.gsub!(/5F5F/, '__')
        trname.gsub!(/23/, '#')
        @manual_entry = trname
      end

      super(source)
    end

  end
end
