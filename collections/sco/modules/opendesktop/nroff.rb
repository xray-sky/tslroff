# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/23/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# SCO OpenDesktop Platform Overrides
#
# TODO
#   losing capital letters in command names (e.g. Xsco) from output files
#

module OpenDesktop
  class Nroff < Nroff

    def initialize(source, **kwargs)
      #@manual_entry ||= source.file.sub(/(?:_bsd|_.+fs|_s5|_xnx)?\.(?:[\dZz]\S?)$/, '')
      @manual_entry ||= source.file.sub(/\.(?<filesection>[A-Ztm]+)\.?[zZ]?$/, '') # .Xm, .Xt from ODT SDS
      @manual_section = Regexp&.last_match&.[](:filesection)
      @heading_detection ||= %r(^ {1,5}(?<section>[A-Z][A-Za-z\s]+)$)
      @title_detection ||= %r{^ {1,5}(?<manentry>(?<cmd>\S+?)\((?<section>[A-Z]+)\))\s+} # was mis-detecting title-less SysV/386 SDS pages because para text leading whitespace is "\t  "
      @related_info_heading ||= 'See also'
      super(source, **kwargs)
      @lines_per_page = nil
    end

    def parse_title
      title = get_title or warn "reached end of document without finding title!"
      return unless title
      @manual_entry     = title[:cmd].downcase # this is where I'm losing capital letters... REVIEW philosophical conflict between all caps title and truncated filename
      @manual_section   = title[:section]
      title
    end

    # SCO uses alphabetic section names
    def detect_links(line)
      # make sure we break detection on space or punctuation, in order to correctly
      line.scan(/(?<=[\s,.;])((\S+?)\(([A-Z]+?)\))/).map do |text, ref, section|
        [text, "../man#{section}/#{ref}.html"]
      end.to_h
    end

    def output_directory
      @manual_section and return "man#{@manual_section}"
      super
    end

  end
end
