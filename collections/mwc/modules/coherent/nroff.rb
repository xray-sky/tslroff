# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/05/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# MWC Coherent Platform Overrides
#
# TODO
#   see also - linkify sectionless refs. some with, some without '()'
# √ fix names starting with # in index. (need url-encoding)
# √ page titles
#

module Coherent
  class Nroff < Nroff

    def initialize(source, **kwargs)
      @heading_detection ||= %r(^\*\*\*\*\* (?<section>[A-Z][A-Za-z\s]+) \*\*\*\*\*$)
      @title_detection ||= %r{^(?<manentry>(?<cmd>\S.*?))\s{2,}(?<section>\S.+?)\s{2,}\k<manentry>$}
      #@related_info_heading ||= 'See Also'

      case source.file
      when /^_(23|5F)/
        trname = source.file.slice(1..-1)
        trname.gsub!(/5F5F/, '__')
        trname.gsub!(/23/, '#')
        @manual_entry = trname
      end

      super(source, **kwargs)
    end

    def manual_section
      case @manual_section
      when /\)$/
        @manual_section.sub(/^(.+?)( \(.+)$/, '\1s \2')
      when nil, 'STDIO', /s$/, /nformation$/, /anguage$/
        @manual_section
      else
        "#{@manual_section}s"
      end
    end

    #def manual_entry
    #  @altname
    #end

    def name_lines
      iter = @document[0].text.each
      iter.next while iter.peek.empty?
      iter.next # skip title line
      iter.next while iter.peek.empty?
      iter.peek # next non-blank line
    end

    def index_entry(nameline)
      return if nameline.empty?
      descr = nameline.to_html
      return [ @manual_entry, descr ] if @manual_entry == @altname
      [ "#{@altname}, #{@manual_entry}", descr ]
    end

    def page_title
      "#{@altname} &mdash; #{manual_section} &mdash; #{@platform} #{@version}"
    end

    def parse_title
      super.tap { |t| @altname = t&.[](:manentry) }
    end

  end
end
