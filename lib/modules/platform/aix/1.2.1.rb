# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/07/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# IBM AIX PS/2 1.2.1 Platform Overrides
#
# TODO:
#  running into case insensitive filesystem issues on output side (PAD.3 vs pad.3)
#  300s(1g) + others - symlinks not being generated
#  several pages - See the following commands: "foo," "bar" and "baz."
#                  In this book: "spqr, wombat," "crumb," "fart," and "garbage."
#                  In this book: "extended curses library," "termdef," and "terminfo."
#  greek(7) has no shift in/out?

class Source
  def magic
    case File.basename(@filename)
    # incorrectly recognized as troff source as the first character is '.'
    when '3270keys.5', 'cshrc.5', 'netrc.5', 'rhosts.5' then 'Nroff'
    else @magic
    end
  end
end

module AIX_1_2_1

  def self.extended(k)
    k.instance_variable_set '@manual_entry', k.instance_variable_get('@input_filename').sub(/\.(\d\S?)$/, '')
    k.instance_variable_set '@heading_detection', %r(^(?<section>[A-Z][A-Z\s]+)$)
    k.instance_variable_set '@title_detection', %r{^(?<manentry>(?<cmd>[-+_., A-Za-z0-9]+?)\((?<section>\S+?),(?<book>[CLF])\))}
    k.instance_variable_set '@related_info_heading', 'RELATED INFORMATION'
    case k.instance_variable_get '@input_filename'
    when 'index.3'
      k.instance_variable_set '@manual_entry', '_index'
    when 'mark.1m', 'pick.1m', 'repl.1m'
      k.define_singleton_method :detect_links, k.method(:detect_links_alt)
    when 'Remote_Procedure_Call_(RPC).3n'
      k.instance_variable_set '@title_detection', %r{^(?<manentry>(?<cmd>REMOTE PROCEDURE CALL \(RPC\))\((?<section>\S+?),(?<book>[CLF])\))}
    when 'XDR__eXternal_Data_Representation.3n'
      k.instance_variable_set '@title_detection', %r{^(?<manentry>(?<cmd>XDR \(EXTERNAL DATA REPRESENTION\))\((?<section>\S+?),(?<book>[CLF])\))}
    when 'acctdir.8'
      k.instance_variable_set '@title_detection', %r{^(?<manentry>(?<cmd>acct/\*)\((?<section>\S+?),(?<book>[CLF])\))}
    end
  end

  def page_title
    "#{super} &mdash; AIX PS/2 1.2.1"
  end

  def parse_title
    title = get_title or warn "reached end of document without finding title!"
    return unless title
    @manual_section   = title[:section]
    @manual_book      = {'C' => 'Commands', 'F' => 'Files', 'L' => 'Libraries'}[title[:book]]
    @output_directory = "man#{@manual_section}"
    title
  end

  def retarget_symlink # looks like these are all same-directory links, though via absolute path for some reason
    #link_dir = Pathname.new @source_dir
    target_dir = Pathname.new File.dirname(@symlink).sub(%r(^/usr/man), '..')
    real_target = File.realpath("#{@source_dir}/#{target_dir}/#{File.basename(@symlink)}")

    # instantiating target to get any local transforms on @manual_entry (which is based on input file name)
    target_entry = Manual.new(real_target, @platform, @version)
    { link: "#{target_entry.output_directory}/#{@manual_entry}.html",
      target: "#{target_entry.manual_entry}.html" }
  end

  # manual references are degenerate in aix ps/2
  # - no section reference, just an inconclusive "book" reference (e.g. "in this book")
  # - REVIEW: 450(1g) has 'troff' refs twice on one line, might need to do something so both get linked?
  # - RPC(5) has 'The rpcinfo command in the...'
  # - System.Netid(5) has 'The rdrdaemon, uvcp, and vuvp commands in the...'
  # - a.out(5) has both types, plus "commands" at the start of the next line
  #
  # REVIEW: might need to parse command|file|program|procedure (+ "miscellaneous facility"??) to guess at section
  #         if we end up needing to get it closer (e.g. greek(1) vs greek(5))

  def detect_links(line)
    @refs_continue = nil if line.match?(/^\s*$/) # new paragraph, no links split across lines
    return detect_links_quoted(line) if @refs_continue == :quoted
    return detect_links_quoted_continue(line) if @refs_continue == :quoted_break
    return detect_links_unquoted_continue(line) if @refs_continue == :unquoted
    return detect_links_quoted(line) if line.match?(/(?:[Ss]ee|book).*?:/) #(?<cmdlist>(?:"(?<cmd>[^"]+)[,.]?"\s(?:and\s)*)+)/)
    return detect_links_unquoted(line) if line.match?(/^(?:See t|T)he [^.]+ (?:command|file|miscellaneous facilit|program|procedure|system call)/)
    {}
  end

  def detect_links_alt(line)
    @refs_continue = nil if line.match?(/^\s*$/) # new paragraph, no links split across lines
    return detect_links_quoted(line) if @refs_continue == :quoted
    return detect_links_quoted_continue(line) if @refs_continue == :quoted_break
    return detect_links_unquoted_continue(line) if @refs_continue == :unquoted
    return detect_links_quoted(line) if line.match?(/^(?:See the|Other).*?(?:command|file|miscellaneous facilit|program|procedure|system call).*"/)
    return detect_links_unquoted(line) if line.match?(/^(?:See t|T)he [^.]+ (?:command|file|miscellaneous facilit|program|procedure|system call)/)
    {}
  end

end


