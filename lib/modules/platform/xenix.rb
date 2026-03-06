# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/23/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# SCO OpenDesktop Platform Overrides
#
# TODO
#   machine(hw) - See Also not detected because of tbl shme
#
class Xenix
  class Nroff < ::Nroff

    def initialize(source)
      @heading_detection ||= %r(^\s{5}(?<section>[A-Z][A-Za-z\s]+)$)
      @title_detection ||= %r{^\s+(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))\s.+?\s\k<manentry>$}
      @related_info_heading ||= 'See Also'
      super(source)
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
