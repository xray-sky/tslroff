# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/04/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# Apollo DomainOS Platform Overrides
#
# nroff seems to be formatted for screen (three part title appears only at top;
# no page length, even for pages which retain overstrikes)
#
# some troff mixed in
#
# REVIEW do I really want to downcase all the sections? 3X11 wants to be uppercase.
# TODO
#   10.4 SysV coffdump(1) links to a.out(5) - should be a.out(4)
#   10.4 SysV/BSD X11 pages mostly missing (only dangling symlinks - extract issue)
# √ 10.4 new  mh sources usr/new/lib/mh/components, usr/new/lib/mh/distcomps (extract issue)
# √ 10.4 new  most of rcs*.n refs "entry (n)" (with a space)
#   10.4 new  ali.n has &minus; in link - Nokogiri is garbling this in the Menu
#   10.4 new  anno.n has the same problem as rcs with whitespace in refs - but these are Troff
# √ 10.4 new  doesn't give systype; put BSD override on mh manual (some links in new/, some in BSD)
#   10.4 new  need to get systype into Related Info links for Troff
#   10.4 Softbench manual doesn't use .TH, which breaks a lot of assumptions
#   10.4 Softbench manual doesn't give systype, which breaks Related Info links
#

module Aegis
  class Nroff < Nroff

    include Utils

    def initialize(source, **kwargs)
      @systype = Regexp.last_match[1] if source.dir.match(%r{(bsd|sys5)})
      @manual_entry = source.file if source.dir.end_with? '/doc'  # release notes REVIEW
      @manual_entry ||= "#{source.file.sub(/\.(?:[\danZz][A-Za-z]?|hlp)$/, '')}#{".#{@systype}" if @systype}"
      @title_detection ||= %r{^\s*(?<manentry>(?<title>\S+?)(?:\((?<section>\S+?)\)(?:\(.+?\))?)?)\s+(?<systype>.+?)\s+\k<manentry>}
      #@base_indent ||= 5  # REVIEW unimplemented

      super(source, **kwargs)

	  if @source.file.end_with? '.a'
	    @manual_section = 'A'
	    define_singleton_method :detect_links, method(:detect_links_syscalls)
        @lines_per_page = nil # REVIEW this was everything?
	  end
    end

    def page_title
      t = @manual_entry.sub(/\.#{@systype}$/, '')
      t << "(#{@manual_section})" unless @manual_section == 'help'
      t << " &mdash; #{@systype}" if @systype
      t << " &mdash; Apollo"
    end

    def parse_title
      title = super
      # pages from usr/new/mann won't have a directory-based systype, but we may have
      # one from the title line (if present).
      # TODO: multiple sources for X11 pages, systype detection not helpful (see: SR10.4.1 mkfontdir)
      unless @systype
        @systype = case title&.[](:systype)
                   when /bsd/i    then 'bsd'
                   when /sys.*v/i then 'sysv'
                   end
        @manual_entry << ".#{@systype}" if @systype
      end
      # use the section from the filename as a default if the title line doesn't
      # have one (and consequently won't be detected) - also covers the 'mana' section
      # REVIEW: this regex doesn't catch every section (e.g. .3x11) though in
      #         practice it catches everything in 10.4 that needs catching.
      @output_directory ||= @source.file.sub(/^.+\.([an\d][a-z]?)$/, 'man\1')
    end

    # normal unix, with systype inserted before .html
    # also do something with "cp in the Aegis Command Reference" (SR10.4 pad(4) BSD)
    # there are a handful of refs like this in the unix manual, all to either 'sh' or 'cp'.
    # (so probably we don't have to worry about detecting help/ subdirectory refs)
    def detect_links(line)
      if line.match(/(?<ref>[_$.a-z0-9]+) in the Aegis Command Reference/)
        return { Regexp.last_match[:ref] => "../help/#{Regexp.last_match[:ref]}.html" }
      end
      line.scan(/(?<=[\s,.;])((\S+?)\((\d.*?)\))/).map do |text, ref, section|
        [text, "../man#{section.downcase}/#{ref}#{'.' + @systype if @systype}.html"]
      end.to_h
    end

    # aegis help style detection for refs in mana/ - bare lists of single refs
    # strip $ for linking into mana/
    #
    # looks like I can rely on presence of _$ to aid detection, if necessary;
    # though they appear totally orderly so maybe unnecessary.
    def detect_links_syscalls(line)
      syscall_detect = '([_$a-z0-9]+)'
      #return unless line.match(/^\s{#{@base_indent}}(?:#{syscall_detect}(?:, |,\s*$|\.\s*$|;\s*$))+/)
      return unless line.match(/^\s{5,}(?:#{syscall_detect}(?:, |,\s*$|\.\s*$|;\s*$))+/)

      line.scan(/#{syscall_detect}/).map do |text, _|
        [text, "#{text.delete '$'}.html"]
      end.to_h
    end

    # Related help references in the Aegis help files are not consistently
    # formatted. There are two types that are easy to detect and a bunch
    # of miscellaneous garbage to deal with besides.
    #def detect_links_aegis_helpfile(line)
    #end

    # the bloody rcs manual in usr/new/mann (inconsistently) has whitespace
    # between the manual entry and section reference
    def detect_links_rcs(line)
      line.scan(/(?<=[\s,.;])((\S+?)\s?\((\d.*?)\))/).map do |text, ref, section|
        [text, "../man#{section.downcase}/#{ref}#{".#{@systype}" if @systype}.html"]
      end.to_h
    end

    # SysV coffdump(1) refers to a.out(5) - for SysV it's actually in section 4
    def detect_links_sysv_coffdump(line)
      line.scan(/(?<=[\s,.;])((\S+?)\((\d.*?)\))/).map do |text, ref, section|
        section.tr!('5', '4')
        [text, "../man#{section.downcase}/#{ref}#{".#{@systype}" if @systype}.html"]
      end.to_h
    end

    def output_directory
      return 'mana' if @source.file.end_with? '.a'
      super
    end

  end
end
