# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/04/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# Apollo DomainOS Platform Overrides
#
# "help" format is plain text, with directory structure, some in-line metadata,
#  and somewhat different rules around "SEE ALSO"
#
# TODO
# √ 10.4 Help edacl has "SEE ALS0" section
# √ 10.4 Help kbd has incorrectly indented related info text
# √ 10.4 Help prsvr/config link to 'prsvr' not detected (next line extra indent on For)
# √ 10.4 Help login/window links to 'l' (single letter link not detected); 's' is only other single char help
#   10.4 Help emt_function_keys [2]: processing unknown escape sequence [E
#             but: 'help emt emt_function_keys' does not result in displaying this file.
#             at minimum, changes the display font size. 5x9 for emt, 5x7 (corrupted by col?) for em3270
#             guess: ^]J starts font change request
#                    next char is length of font name (number of characters) - ^D was 4, ^E is 5; if it's wrong, you get the extra characters echoed as normal text
#                    then the string with the font name (f5x7, f5x9, f7x13, helvetica12; default pad font seems to be f16.b)
#                    ^[E terminates the name
#                    ^A ? is important; no change without this.
#   consider allowing related info detection in index.hlp (commands.hlp, dm.hlp... no "SEE ALSO")

module Aegis
  class Help < Nroff

    @@help_sections = %w[calls debug dm ed edacct edns edstr em3270 emt fmt login magtape protection prsvr shell syscalls vt100].freeze

    include Utils

    def initialize(source, **kwargs)
      @manual_entry ||= source.file.delete_suffix('.hlp')
      # no.
      @title_detection ||= %r{^\s*(?<manentry>(?<title>\S+?)(?:\((?<section>\S+?)\)(?:\(.+?\))?)?)\s+(?<systype>.+?)\s+\k<manentry>}
      @related_info_heading ||= 'RELATED TOPICS'
      # TODO finish implementing @base_indent or get rid of it
      #      but we have been relying on it in detect_links
      @base_indent ||= 2  # REVIEW

      super(source, **kwargs)

      @lines_per_page = nil # REVIEW this was everything?
      @output_directory = @source.dir.match(%r{^.*(help.*)$})[1]
      @manual_section = @output_directory.tr('/', ' ')
      @summary_heading = %r{^#{@manual_entry}\s\(\S+?\)\s+-+\s+\S}
    end

    def detect_links(line)
      # a reference might include a "section" (stored in a subdirectory)
      # e.g. "help calls gpr_$whatever" to give calls/gpr_$whatever.hlp
      # ~or~ "help prsvr/config"
      # in order to detect these, @@help_sections contains an array of all
      # possible sections. in order to further limit the scope for detecting
      # bogus help references, limit the reference to single words containing
      # only lower case letters, numbers, dot, underscore, or dollar. this
      # seems to encompass all available help files. a dot at the end will be
      # punctuation, so don't detect that. (side effect: detects minimum two chars)
      # REVIEW: consider rewriting links for calls or syscalls directly into mana/
      # TODO: might be "section entry" or "section/entry" (see: prsvr)
      entry_detect = "(?<entry>(?:(?:#{@@help_sections.join('|')})[\\s/])?[_$.a-z0-9]+[a-z0-9])"

      # figure out if we are down in the help/ directory hierarchy and need
      # to give some parent directories to a link. for now: assume only one level
      relative_path = (@output_directory == 'help') ? './' : '../'

      case line
      # explicit style; there'll only ever be one reference per line
      #  ^     help  something  descriptive text
      # fortunately this seems most common.
      when /^\s{#{@base_indent},}help\s+#{entry_detect}/, /^\s{#{@base_indent},}#{entry_detect}\s+[Ff]or\s/
        ref = Regexp.last_match
        { ref[:entry] => "#{relative_path}#{ref[:entry].tr(" \t", '/')}.html" }

      # SR9 explicit style; there'll only ever be one reference per line
      #  ^     - HELP  SOMETHING  descriptive text
      when /^\s{#{@base_indent},}- help\s+#{entry_detect}/i
        ref = Regexp.last_match
        { ref[:entry] => "#{relative_path}#{ref[:entry].downcase.tr(" \t", '/')}.html" }

      # syscalls (SR10.3+)
      when /\s{#{@base_indent},}#{entry_detect}(?:,\s+|\.|;)/
        line.scan(/(#{entry_detect})/).map do |text, ref|
          [text, "#{text}.html"]
        end.to_h

      # unix style; could be multiple references, but they're unique enough to
      # detect reliably. The unix-style manual section reference is immaterial;
      # everything is in help/ ...and I think this can't possibly involve @@help_sections
      when /\S+?\(\d.*?\)/
        line.scan(/((\S+?)\(\d.*?\))/).map do |text, ref|
          [text, "#{relative_path}#{ref}.html"]
        end.to_h

      # all the other garbage:
      else
        if line.match(/^\s{#{@base_indent},}#{entry_detect}\s*$/)
          ref = Regexp.last_match
          next_line = unformat(@lines.peek)
          return { ref[:entry] => "#{relative_path}#{ref[:entry].tr(" \t", '/')}.html" } if next_line.match(/^\s{#{@base_indent},}[Ff]or\s/)
        end

        # bare lists of single refs
        # TODO (somehow) setprot.hlp has "protection rights" spanning lines
        #if line.match(/^\s{#{@base_indent}}(?:#{entry_detect}(?:, |,\s*$|\.\s*$|;\s*$))+/)
        if line.match(/^\s{5,}(?:#{entry_detect}(?:, |,\s*$|\.\s*$|;\s*$))+/)
          return line.scan(/#{entry_detect}/).map do |text, _|
            [text, "#{relative_path}#{text.tr(" \t", '/')}.html"]
          end.to_h
        end

        # finally, return an empty hash if we detected nothing at all.
        # returning something (instead of nil) prevents Nroff from
        # checking again at every character position.
        {}
      end
    end

    # REVIEW: nothing?
    #         maybe something with the "metadata", if present?
    def parse_title
    end

    def page_title
      String.new "#{@manual_entry} &mdash; Apollo"
    end

    def output_directory
      @source.dir.sub(%r{^.*/(help)}, '\1')
    end

    private

    def name_lines
      @document[0].text.detect { |l| h = l.to_html.strip ; h.include?(' -- ') or h.include?(' - ') }
    end

    def index_entry(line)
      return unless line
      (names, _sep, descr) = line.to_html.strip.partition(/\s+-+\s+/)
      [names.sub(/^.*\((\S+)\).*$/, '\1'), descr]
    end

    # TODO filter names for @manual_entry with UPCASE; add e.g. CC to cc_dm
    #      suggests having erb defer to man.method for this

  end
end
