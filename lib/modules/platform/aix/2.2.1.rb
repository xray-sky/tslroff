# encoding: US-ASCII
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

module AIX_2_2_1

  def self.extended(k)
    k.instance_variable_set '@manual_entry',
      k.instance_variable_get('@input_filename').sub(/\.(?<section>\d\S?)(?:\.[zZ])?$/, '')
    k.instance_variable_set '@manual_section', Regexp.last_match&.[](:section)
    k.instance_variable_set '@title_detection', %r{^(?<manentry>(?<cmd>[-+_., A-Za-z0-9]+))}
    k.instance_variable_set '@lines_per_page', nil
    k.instance_variable_set '@base_indent', 5

    src = k.instance_variable_get '@source'
    ## this is working to set the input encoding and avoid the invalid character exception,
    ## but I'm getting nonsense characters out.
    ##src.lines.collect! { |k| k.force_encoding Encoding::IBM437 }
    ## this generates the correct translations of CP437 -> UTF-8 (with <meta charset="UTF-8">)
    ## but compare to what actually shows on the RT, both on the console and in aixterm
    ##  - printed doc matches our guesses, but not description of RT CP0 from `data stream`(4)
    #src.lines.collect! { |k| k.force_encoding(Encoding::IBM437).encode!(Encoding::UTF_8) }
    src.lines.collect! do |l|
      l.force_encoding Encoding::ASCII_8BIT
      l.sub(%r{(\214|\220|\272|\275)}) do |_cx|
        case Regexp.last_match[1]
        when "\214" then "<\cH_"
        when "\220" then "e\cH'"
        when "\272" then "]"
        when "\275" then "["
        else Regexp.last_match[1]
        end
      end
    end

    if k.instance_variable_get('@manual_section') == '1'
      k.instance_variable_set '@heading_detection', %r(^(?<section>[A-Z][A-Z\s]+)$)
      k.instance_variable_set '@related_info_heading', 'RELATED INFORMATION'
    else
      k.instance_variable_set '@heading_detection', %r{^\s*(?<section>Purpose|Synopsis|Description|Files?|Related Information)$}
      k.instance_variable_set '@related_info_heading', 'Related Information'
    end

    case k.instance_variable_get '@input_filename'
    when 'create_ipc_pro'
      k.instance_variable_set '@manual_entry', 'create_ipc_prof'
      k.instance_variable_set '@manual_section', '3'
    when 'getdtablesize.'
      k.instance_variable_set '@manual_entry', 'getdtablesize'
      k.instance_variable_set '@manual_section', '3'
    when 'gethostbyaddr.'
      k.instance_variable_set '@manual_entry', 'gethostbyaddr'
      k.instance_variable_set '@manual_section', '3'
    when 'index.3'
      k.instance_variable_set '@manual_entry', '_index'
    when 'a.out.5.z'
      k.instance_variable_set '@base_indent', 0
    end
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
