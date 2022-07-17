# encoding: US-ASCII
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
# "help" format is plain text, with directory structure, some in-line metadata,
#  and somewhat different rules around "SEE ALSO"
#
# REVIEW: do I really want to downcase all the sections? 3X11 wants to be uppercase.
# TODO:
#       10.4 SysV coffdump(1) links to a.out(5) - should be a.out(4)
#       10.4 SysV/BSD X11 pages mostly missing (only dangling symlinks - extract issue)
# √     10.4 new  mh sources usr/new/lib/mh/components, usr/new/lib/mh/distcomps (extract issue)
# √     10.4 new  most of rcs*.n refs "entry (n)" (with a space)
#       10.4 new  ali.n has &minus; in link - Nokogiri is garbling this in the Menu
#       10.4 new  anno.n has the same problem as rcs with whitespace in refs - but these are Troff
# √     10.4 new  doesn't give systype; put BSD override on mh manual (some links in new/, some in BSD)
#       10.4 new  need to get systype into Related Info links for Troff
# √     10.4 Help edacl has "SEE ALS0" section
# √     10.4 Help kbd has incorrectly indented related info text
# √     10.4 Help prsvr/config link to 'prsvr' not detected (next line extra indent on For)
# √     10.4 Help login/window links to 'l' (single letter link not detected); 's' is only other single char help
#       10.4 Help emt_function_keys [2]: processing unknown escape sequence [E
#                 but: 'help emt emt_function_keys' does not result in displaying this file.
#                 at minimum, changes the display font size. 5x9 for emt, 5x7 (corrupted by col?) for em3270
#                 guess: ^]J starts font change request
#                        next char is length of font name (number of characters) - ^D was 4, ^E is 5; if it's wrong, you get the extra characters echoed as normal text
#                        then the string with the font name (f5x7, f5x9, f7x13, helvetica12; default pad font seems to be f16.b)
#                        ^[E terminates the name
#                        ^A ? is important; no change without this.
#       10.4 Softbench manual doesn't use .TH, which breaks a lot of assumptions
#       10.4 Softbench manual doesn't give systype, which breaks Related Info links
#       consider allowing related info detection in index.hlp (commands.hlp, dm.hlp... no "SEE ALSO")

module DomainOS

  def self.extended(k)
    systype = Regexp.last_match[1] if k.instance_variable_get('@source_dir').match(%r{(bsd|sys5)})
    k.instance_variable_set '@systype', systype
    k.instance_variable_set '@manual_entry',
      k.instance_variable_get('@input_filename').sub(/\.(?:[\danZz][A-Za-z]?|hlp)$/, '') + (systype ? ".#{systype}" : '')
    # spoilsport: "dde(1)(Domain/OS)" => SR10.4 ./bsd4.3/usr/man/cat1/dde.1
    k.instance_variable_set '@title_detection',
      %r{^\s*(?<manentry>(?<title>\S+?)(?:\((?<section>\S+?)\)(?:\(.+?\))?)?)\s+(?<systype>.+?)\s+\k<manentry>}
    k.instance_variable_set '@base_indent', 5
    k.instance_variable_set '@lines_per_page', nil
    k.define_singleton_method(:req_LP, k.method(:req_PP)) if k.methods.include?(:req_PP)

    # special cases for Aegis help
    # there's a directory hierarchy in help/ - mirror it in the output directories
    # use the directory name to identify (a couple help files aren't named *.hlp)
    #                                    (but these aren't available to 'help'?)
    #                                    (seems to be in-app help - ^F7 for both - be clever and link it to the in-text helpfile reference?)
    # use the directory name to identify anyway, since it gets us a Regexp match for output_directory
    # REVIEW: "help dm commands" is a thing, despite there being no dm/commands.hlp ??
    #   TODO: - there is. it just isn't present in my extraction. fix that.
    # REVIEW: "help syscalls foo" is a thing; syscalls/ is a link to calls/;
    #         everything in calls/ is a link to usr/apollo/man/mana/ (see: mbx.hlp)
    #         but there's more in mana/ than is linked from calls/ (mana/ adds gpr and cd_*)
    #         - names are different too, maybe because of $ in bin/sh vs com/sh ? (vec_$abs.hlp => vec_abs.a)
    # spoilsport: help/index.hlp (=> index.html)
    if k.instance_variable_get('@source_dir').match(/^.*(help.*)$/)
      k.define_singleton_method :detect_links, k.method(:detect_links_aegis_helpfile)
      k.define_singleton_method :parse_title, k.method(:parse_title_aegis_helpfile)
      k.instance_variable_set '@output_directory', Regexp.last_match[1]
      k.instance_variable_set '@manual_section', 'help'
      k.instance_variable_set '@help_sections',
        %w[calls debug dm ed edacct edns edstr em3270 emt fmt login magtape
           protection prsvr shell syscalls vt100]
      # TODO: nope, some of these pages use unix style format, with 'NAME' section heading --- arp has no space following -; bind has no (); cc has no - at all
      k.instance_variable_set '@summary_heading', %r{^#{k.instance_variable_get '@manual_entry'}\s\(\S+?\)\s+-+\s+\S}
    elsif k.instance_variable_get('@input_filename').end_with?('.a')
      k.define_singleton_method :detect_links, k.method(:detect_links_syscalls)
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
    @output_directory ||= @input_filename.sub(/^.+\.([an\d][a-z]?)$/, 'man\1')
  end

  # REVIEW: nothing?
  #         maybe something with the "metadata", if present?
  def parse_title_aegis_helpfile
  end

  def retarget_symlink
    #link_dir = Pathname.new @source_dir
    #target_dir = Pathname.new File.dirname(@symlink)
    #real_target = File.realpath("#{@source_dir}/#{@input_filename}")

    case @symlink
    # mann/, mana/, ../usr/softbench/man/, ../usr/X11/man/
    # disregard links to these directories, if we end up getting them as args
    # they'll be handled separately
    when %r{man[an]$}, %r{usr/(?:softbench|X11)/man}
      return nil
    # sys/help/syscalls/ => ./calls/ -- TODO: sys/help/syscalls got expanded as a directory, rather than detected as a symlink
    when 'calls', './calls'
      return { link: 'syscalls', target: @symlink }
    # sys/help/calls/* => usr/apollo/mana/*
    # also cover broken link oddity, sys/help/calls/gpr_$inq_cp.hlp -> ../../../usr/apollo/mana/gpr_inq_cp.a
    when %r{usr/apollo(?:/man)?/mana/([_a-z0-9]+)\.a$}
      return { link: @manual_entry, target: "../../mana/#{Regexp.last_match[1]}.html" }
    # oddity - sys/help/protection/protected_subsystems.hlp -> /protected_subs.hlp
    when '/protected_subs.hlp' # TODO: this didn't happen?
      # protected_subsystems.hlp: No such file or directory @ rb_sysopen - sys/help/protection/protected_subsystems.hlp
      # so... I'm doing something to make it fail, before we get here? yes: Source.new(file) follows the link, and that's where the exception happens.
      # TODO: need to rewrite prior to source_init, apparently.
      return { link: 'protected_subsystems.html', target: 'protected_subs.html' }
    # TODO: (?)
    # oddity - sys/help/calls/gpr_$inq_cp.hlp -> ../../../usr/apollo/mana/gpr_inq_cp.a
    #          (is usr/apollo/man/mana/gpr...) --- need to rewrite prior to source_init.
    # oddity - sys5.3/usr/catman/u_man/man5/xterm.5 -> ../../../../../usr/X11/man/cat7/xterm.7
    #   $ find . -name 'xterm.*' -ls
    #   4447743      152 -r--r--r--    1 bear             staff               77690 Nov 20  1993 ./usr/X11/man/cat1/xterm.1
    #   4447753       32 -r--r--r--    1 bear             staff               15911 Nov 20  1993 ./usr/X11/man/cat7/xterm.7
    #   4446433        8 lrwxr-xr-x    1 bear             staff                  39 May 30  1991 ./sys5/usr/catman/u_man/man5/xterm.5 -> ../../../../../usr/X11/man/cat7/xterm.7
    #   4446424        8 lrwxr-xr-x    1 bear             staff                  41 May 23  1992 ./sys5/usr/catman/u_man/man1/xterm.1 -> ./../../../../../usr/X11/man/cat1/xterm.1
    #   4443288        8 lrwxr-xr-x    1 bear             staff                  38 May 23  1992 ./bsd4.3/usr/man/cat1/xterm.1 -> ./../../../../usr/X11/man/cat1/xterm.1
    #   4444557        8 lrwxr-xr-x    1 bear             staff                  38 May 30  1991 ./bsd4.3/usr/man/cat7/xterm.7 -> ./../../../../usr/X11/man/cat7/xterm.7
    end
    super
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
    if line.match(/^\s{#{@base_indent}}(?:#{syscall_detect}(?:, |,\s*$|\.\s*$|;\s*$))+/)
      return line.scan(/#{syscall_detect}/).map do |text, _|
        [text, "#{text.tr('$', '')}.html"]
      end.to_h
    end
  end

  # Related help references in the Aegis help files are not consistently
  # formatted. There are two types that are easy to detect and a bunch
  # of miscellaneous garbage to deal with besides.
  def detect_links_aegis_helpfile(line)
    # a reference might include a "section" (stored in a subdirectory)
    # e.g. "help calls gpr_$whatever" to give calls/gpr_$whatever.hlp
    # ~or~ "help prsvr/config"
    # in order to detect these, @help_sections contains an array of all
    # possible sections. in order to further limit the scope for detecting
    # bogus help references, limit the reference to single words containing
    # only lower case letters, numbers, dot, underscore, or dollar. this
    # seems to encompass all available help files. a dot at the end will be
    # punctuation, so don't detect that. (side effect: detects minimum two chars)
    # REVIEW: consider rewriting links for calls or syscalls directly into mana/
    # TODO: might be "section entry" or "section/entry" (see: prsvr)
    entry_detect = "(?<entry>(?:(?:#{@help_sections.join('|')})[\\s/])?[_$.a-z0-9]+[a-z0-9])"

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

    # unix style; could be multiple references, but they're unique enough to
    # detect reliably. The unix-style manual section reference is immaterial;
    # everything is in help/ ...and I think this can't possibly involve @help_sections
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
      # TODO: (somehow) setprot.hlp has "protection rights" spanning lines
      if line.match(/^\s{#{@base_indent}}(?:#{entry_detect}(?:, |,\s*$|\.\s*$|;\s*$))+/)
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

  # the bloody rcs manual in usr/new/mann (inconsistently) has whitespace
  # between the manual entry and section reference
  def detect_links_rcs(line)
    line.scan(/(?<=[\s,.;])((\S+?)\s?\((\d.*?)\))/).map do |text, ref, section|
      [text, "../man#{section.downcase}/#{ref}#{'.' + @systype if @systype}.html"]
    end.to_h
  end

  # SysV coffdump(1) refers to a.out(5) - for SysV it's actually in section 4
  def detect_links_sysv_coffdump(line)
    line.scan(/(?<=[\s,.;])((\S+?)\((\d.*?)\))/).map do |text, ref, section|
      section.tr!('5', '4')
      [text, "../man#{section.downcase}/#{ref}#{'.' + @systype if @systype}.html"]
    end.to_h
  end

  # Troff methods <= tmac.an

  def init_ds
    super
    @state[:named_string].merge!({
      'lq' => '&ldquo;',
      'rq' => '&rdquo;',
      'R'  => '&reg;',
      'S'  => "\\s#{Font.defaultsize}"
    })
  end

  # tmac.an.new
  def req_AT(*args)
    req_ds(']W', case args[0]
                 when '3' then '7th Edition'
                 when '4' then 'System III'
                 when '5' then "System V#{' Release ' + args[1] if args[1]}"
                 else '7th Edition'
                 end
          )
  end

  # tmac.an.new
  def req_UC(v = nil)
    req_ds(']W', case v
                 when '3' then '3rd Berkeley Distribution'
                 when '4' then '4th Berkeley Distribution'
                 when '5' then '4.2 Berkeley Distribution'
                 when '6' then '4.3 Berkeley Distribution'
                 else '3rd Berkeley Distribution'
                 end
          )
  end
end
