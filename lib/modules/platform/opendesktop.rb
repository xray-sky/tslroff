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

class OpenDesktop
  class Nroff < ::Nroff

    def initialize(source)
      #@manual_entry ||= source.file.sub(/(?:_bsd|_.+fs|_s5|_xnx)?\.(?:[\dZz]\S?)$/, '')
      @manual_entry ||= source.file.sub(/\.(?:[A-Z]+)\.?[zZ]?$/, '')
      @heading_detection ||= %r(^\s(?<section>[A-Z][A-Za-z\s]+)$)
      @title_detection ||= %r{^\s(?<manentry>(?<cmd>\S+?)\((?<section>[A-Z]+)\))\s+}
      @related_info_heading ||= 'See also'
      super(source)
      @lines_per_page = nil
    end

    def parse_title
      title = get_title or warn "reached end of document without finding title!"
      return unless title
      @manual_entry     = title[:cmd].downcase
      @manual_section   = title[:section]
      @output_directory = "man#{@manual_section}"
      title
    end

    # SCO uses alphabetic section names
    def detect_links(line)
      # make sure we break detection on space or punctuation, in order to correctly
      line.scan(/(?<=[\s,.;])((\S+?)\(([A-Z]+?)\))/).map do |text, ref, section|
        [text, "../man#{section}/#{ref}.html"]
      end.to_h
    end

  end
end

class SCO_SysV386 < OpenDesktop ; end
