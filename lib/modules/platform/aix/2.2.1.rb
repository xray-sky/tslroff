# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/12/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# IBM AIX RT 2.2.1 Platform Overrides
#
#  non-ascii characters:            CP437     Printed doc
#     adb.1      0x8c (≤ ??)        î         ≤
#     ctab.1     0x90 (é ??)        É         é
#     ged.1      0x8c (≤ ??)        î         ≤
#     nohup.1    °    (0xba ??)     ║         ]    (probably this was meant to be |, there are other places | substitutes for ])
#     nroff.1    0x8c (≤ ??)        î         ≤
#     auditlog.2 0x8c (≤ ??)        î         ≤
#     dsstate.2  ½    (0xbd ??)     ╜         [
#     exec.2     ½    (0xbd ??)
#     fullstat.2 ½    (0xbd ??)
#     loadtbl.2  ½    (0xbd ??)
#     mntctl.2   ½    (0xbd ??)
#     open.2     ½    (0xbd ??)
#     pipe.2     ½    (0xbd ??)
#     select.2   ½    (0xbd ??)
#     (--more--)
#
#  greek(7) has a hilarious bug (how did that happen??) and wants a couple characters translated too
#  mv(7) has tofu

class AIX::V2_2_1
  class Nroff < ::Nroff

    EXTENDED_CHARACTER_TRANSLATIONS = {
      "\x8C".force_encoding(Encoding::ASCII_8BIT) => "<\cH_",
      "\x90".force_encoding(Encoding::ASCII_8BIT) => "e\cH'",
      "\xBA".force_encoding(Encoding::ASCII_8BIT) => ']',
      "\xBD".force_encoding(Encoding::ASCII_8BIT) => '['
    }

    EXTENDED_CHARACTERS = EXTENDED_CHARACTER_TRANSLATIONS.keys.join()

    def initialize(source)
      @manual_entry ||= source.file.sub(/\.(?<section>\d\S?)(?:\.[zZ])?$/, '')
      @manual_section ||= Regexp.last_match[:section] if Regexp.last_match
      # REVIEW do we have the manual section in every case (section 1 specifically)?
      @heading_detection ||= @manual_section == '1' ? %r(^(?<section>[A-Z][A-Z\s]+)$) : %r{^\s*(?<section>Purpose|Synopsis|Description|Files?|Related Information)$}
      @related_info_heading ||= @manual_section == '1' ? 'RELATED INFORMATION' : 'Related Information'
      @title_detection ||= %r{^(?<manentry>(?<cmd>[-+_., A-Za-z0-9]+))}
      @base_indent ||= 5

      super(source)

      @lines_per_page = nil
    end

    def source_init
      # REVIEW: have I made changes allowing this to be done more orderly? external encoding?

      ## this is working to set the input encoding and avoid the invalid character exception,
      ## but I'm getting nonsense characters out.
      ##src.lines.collect! { |k| k.force_encoding Encoding::IBM437 }

      ## this generates the correct translations of CP437 -> UTF-8 (with <meta charset="UTF-8">)
      ## but compare to what actually shows on the RT, both on the console and in aixterm
      ##  - printed doc matches our guesses, but not description of RT CP0 from `data stream`(4)
      #src.lines.collect! { |k| k.force_encoding(Encoding::IBM437).encode!(Encoding::UTF_8) }

      @source.lines.collect! do |l|
        l.force_encoding Encoding::ASCII_8BIT
        l.gsub(%r{[#{EXTENDED_CHARACTERS}]}, EXTENDED_CHARACTER_TRANSLATIONS)
      end

      # 14 char filename length damage
      case @source.file
      when 'create_ipc_pro'
        @manual_entry = 'create_ipc_prof'
        @manual_section = '3'
      when 'getdtablesize.'
        @manual_entry = 'getdtablesize'
        @manual_section = '3'
      when 'gethostbyaddr.'
        @manual_entry = 'gethostbyaddr'
        @manual_section = '3'
      when 'index.3'   then @manual_entry = '_index'
      when 'a.out.5.z' then @base_indent = 0
      end
      super
    end

    def page_title
      super << " &mdash; AIX/RT 2.2.1"
    end

    def parse_title
      title = get_title or warn "reached end of document without finding title!"
      #@manual_entry = title[:cmd] # some of these manual entries are >14char (filename length limit)
      @output_directory = "man#{@manual_section}" if @manual_section
      title
    end

    # manual references are degenerate in aix rt
    # - no section reference, just an inconclusive "book" reference (e.g. "in this book")
    # - REVIEW 450(1g) has 'troff' refs twice on one line, might need to do something so both get linked?
    # - RPC(5) has 'The rpcinfo command in the...'
    # - System.Netid(5) has 'The rdrdaemon, uvcp, and vuvp commands in the...'
    # - a.out(5) has both types, plus "commands" at the start of the next line
    #
    # REVIEW might need to parse command|file|program|procedure (+ "miscellaneous facility"??) to guess at section
    #        if we end up needing to get it closer (e.g. greek(1) vs greek(5))

    def detect_links(line)
      @refs_continue = nil if line.match?(/^\s*$/) # new paragraph, no links split across lines
      return detect_links_quoted(line) if @refs_continue == :quoted
      return detect_links_quoted_continue(line) if @refs_continue == :quoted_break
      return detect_links_unquoted_continue(line) if @refs_continue == :unquoted
      return detect_links_quoted(line) if line.match?(/(?:following|book|commands?).*?:/)
      return detect_links_unquoted(line) if line.match?(/^\s{#{@base_indent}}(?:See t|T)he (?:a\.out)?[^.]+ (?:command|file|miscellaneous facilit|program|procedure|system call)/)
      {}
    end

    def detect_links_alt(line)
      @refs_continue = nil if line.match?(/^\s*$/) # new paragraph, no links split across lines
      return detect_links_quoted(line) if @refs_continue == :quoted
      return detect_links_quoted_continue(line) if @refs_continue == :quoted_break
      return detect_links_unquoted_continue(line) if @refs_continue == :unquoted
      return detect_links_quoted(line) if line.match?(/^\s{#{@base_indent}}(?:See the|Other).*?(?:command|file|miscellaneous facilit|program|procedure|system call).*"/)
      return detect_links_unquoted(line) if line.match?(/^\s{#{@base_indent}}(?:See t|T)he [^.]+ (?:command|file|miscellaneous facilit|program|procedure|system call)/)
      {}
    end

  end
end
