# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/04/23.
# Copyright 2023 Typewritten Software. All rights reserved.
#
#
# VMS Platform Overrides
# Requires .HLB library files be pre-processed into .HLP text with LIBRARY/EXTRACT=*
#
# TODO
#   do straight text (e.g. release_notes)
#   page titles
#   do the HTML properly, with Block and Text objects
# √ detect anchor links
# √ insert command/qualifier links
#   do better link sidebars than just "related"
#    -- maybe also include a grey subhead for section names, under which the anchors are linked?
# √ observe whether there are any tabs to obey (or is it all spaces)
#    -- there are. as long as we are deferring to ::Nroff, it's fine.
#   interaction between various level headings and Block::Nroff indent (~around <h4> is when it gets "bad")
# √ review HELP RUNOFF (4.4) to understand how the qualifiers are presented
#    -- we've got RUNOFF, RUNOFF/CONTENTS, and RUNOFF/INDEX, plus the qualifiers for RUNOFF itself
#    -- at the top level, maybe it should be part of Commands (like MAIL/EDIT) ?
#        -- this might be helplib specific, in that case.
# √ Commands linked at level 1 of command page (edfhlp.hlb/invoke.html) are not linked as anchors
#   Some mixed-case level-1 sections should probably be done as "commands" (e.g. DECthreads, RTL Routines, System Services, NewFeatures...)
#   RUNOFF has two major sections, each with /PAGE_NUMBERS qualifiers - only the first anchor works
#    -- try to put section breadcrumbs in anchors, maybe
#   maybe try to detect monospace vs. paragraph, table, example, external links (if there are any?)
#   maybe try to detect in-text links (e.g. "See the SET command for [...]")
#   ANSI escapes (e.g. tpuhelp.hlb)
#
# REVIEW whether the µVMS 4.6 RUNOFF help refs actually cut out the extra parameter text (/FOO[=bar])
#

# load enough of troff to make tabs work, for laying out hyperlinks
require_relative '../dom/troff/request/nr'
require_relative '../dom/troff/request/ta'
require_relative '../dom/troff/expressions'
require_relative '../dom/troff/tabs'
require_relative '../dom/troff/util'

module VMS
  def self.extended(k)
    k.instance_variable_set '@lines_per_page', nil
    k.instance_variable_set '@manual_entry', k.instance_variable_get('@input_filename').sub(/\.hl.$/, '')
    k.instance_variable_set '@register', {}
    k.instance_variable_set '@state', {}
    k.extend Troff # it gives tabs
    k.send :xinit_selenium
    k.send :xinit_nr
    k.send :init_ta
    #k.send :req_ta, '.75i 1.5i 2.25i 3i 3.75i 4.5i 5.25i 6i'
    k.send :req_ta, '1i 2i 3i 4i 5i 6i'
    case k.instance_variable_get '@input_filename'
    when /\.[ht]lb$/
      raise ManualIsBlacklisted, 'is packed library'
    when /\.txt$/, /\.release_notes$/
      raise ManualIsBlacklisted, 'unpacked text library (TODO)'
    when 'dbg$dwhelp.hlp', 'ddif$view.hlp', /^decw\$/, 'macro$dwci.hlp',
         'cms$dw_help.hlp', 'fortran$dwci.hlp', 'lisp$decwindows.hlp', 'pascal$dwci.hlp',
         'keyutil.hlp' #LogiCraft 386ware
      raise ManualIsBlacklisted, 'TODO DDIF? (=include, =Title)'
    when 'config.hlp', 'menu.hlp', # LogiCraft 386ware
         'keypad.hlp', 'pcxtkeys.hlp', 'queues.hlp', 'secaudit.hlp' # Sybase Data Workbench
      raise ManualIsBlacklisted, 'not VMS HELP Library format'
    end
  end

  def parse_title
    # what does this mean when a single .hlb can have many separate entries
    @helplib_dir = @input_filename.sub(/hlp$/, 'hlb')
  end

  def to_html

    #ppid = Process.pid
    hlb = VMSHelpLibrary.new(hlbname(@manual_entry), @source)
    helplib = hlbname(@manual_entry)
    # VMS HELP puts these in the order of the keys, with a break before and after the Qualifiers (as a unit)
    pagelinks = {commands: [], qualifiers: [], subsections: []}
    pagehead = Block::Header.new(text: Text.new(text: "#{helplib} &mdash; #{@platform} #{@version}"))
    pagefoot = "\n</div></div>" # TODO what is the correct Object form of this
    pagetext = hlb.subsections.collect do |mod|
      pagelinks[:subsections] << Block::Link.new(text: Text.new(text: mod.name), href: "##{mod.name}")
      mod_to_html mod, h1: true
    end.join
    pagelinks[:commands] = hlb.commands.collect do |command|
      # somehow getting a "helplib.hlb/.html" link between subsections and commands links
      next if command.name.strip.empty?
      # TODO make this .tr / _ reusable somehow
      Block::Link.new(text: Text.new(text: command.name), href: "#{@helplib_dir}/#{command.name.tr('/', '_')}.html")
    end

    hlb.commands.each do |mod|
      pid = fork
      if pid
        Process.waitpid(pid)
      else
        @manual_entry = mod.name
        @output_directory = @helplib_dir
        pagehead = Block::Header.new(text: Text.new(text: "#{helplib} #{mod.name} &mdash; #{@platform} #{@version}"))
        pagelinks = {commands: [], qualifiers: [], subsections: []}
        pagetext = mod_to_html mod
        break
      end
    end
    pagehead.to_html + format_links(pagelinks) + pagetext + pagefoot
  end

  private

  def format_links(hsh)
    heading = Block::SubSubHead.new(text: "Additional information available:")
    links = [:commands, :subsections, :qualifiers].collect do |k|
      @current_block = Block::Paragraph.new
      hsh[k].each do |link|
        next unless link # might've gotten a nil from .collect
        @current_block << link # we're already given a Block::Link object
        @current_block << Text.new # prevent insert_tab from getting confused about missing styles
        stop = next_tab
        if stop
          insert_tab(width: to_em(stop - @current_block.last_tab_position), stop: stop)
        else
          @current_block << LineBreak.new
        end
      end
      @current_block.empty? ? Block::Bare.new : @current_block
    end.collect(&:to_html).join
    links.empty? ? '' : heading.to_html + links
  end

  def mod_to_html(mod, h1: false)
    # TODO increase heading level of qualifiers by one (...probably?)
    #        ==> counterargument: exchnghlp (qualifiers are not subheads of Description)
    #            maybe only do this if we are children of a section named "Qualifiers"?
    depth = mod.depth
    pagelinks = {}
    modulehead = ''
    modulehead = %(<a name="#{mod.linkname}"><h#{depth}>#{mod.name}</h#{depth}></a>) if h1 or depth>1
    moduletext = (@lines = mod.text.each ; to_lp.collect(&:to_html).join)
    subsectiontext = mod.all_subsections.collect { |s| mod_to_html s }.join
    pagelinks[:subsections] = mod.subsections.collect { |s| Block::Link.new(text: Text.new(text: s.name), href: "##{s.name}") }
    pagelinks[:qualifiers] = mod.qualifiers.collect { |q| Block::Link.new(text: Text.new(text: q.linkname), href: "##{q.linkname}") }
    pagelinks[:commands] = mod.commands.collect do |c|
      next if c.name.strip.empty? # REVIEW maybe this should be done in the detector method
      Block::Link.new(text: Text.new(text: c.name), href: "##{c.name}")
    end
    modulehead + moduletext + format_links(pagelinks) + subsectiontext
  end

  def hlbname(hlb)
    case hlb
    when /acledt/i    then 'ACL Editor' # REVIEW
    when /anlrmshlp/i then 'ANALYZE/RMS_FILE'
    when /analaudit/i then 'ANALYZE/AUDIT'
    when /cafhelp/i   then 'CLUSTER_AUTHORIZE'
    when /debughlp/i  then 'DEBUG'
    when /dbg\$help/i then 'DEBUG'
    when /diskquota/i then 'DISKQUOTA'
    when /dtehelp/i   then 'DTEPAD'
    when /dtsdtr/i    then 'DTS and DTR'
    when /edfhlp/i    then 'EDIT/FDL'
    when /edthelp/i   then 'EDT'
    when /ess\$ladc/i then 'LADCP'
    when /ess\$last/i then 'LASTCP'
    when /eve\$help/i then 'EVE'
    when /eve\$keyh/i then 'EVE Keyboard'
    when /exchnghlp/i then 'EXCHANGE'
    when /helplib/i   then 'HELP'
    when /instalhlp/i then 'INSTALL'
    when /latcp/i     then 'LATCP'
    when /lmcp\$hlb/i then 'LMCP' # Log Manager Control Program
    when /mailhelp/i  then 'MAIL'
    when /mnrhelp/i   then 'MONITOR'
    when /ncphelp/i   then 'DECnet NCP'
    when /patchhelp/i then 'PATCH'
    when /phonehelp/i then 'PHONE'
    when /^sda/i      then 'System Dump Analyzer' # SDA
    when /shwclhelp/i then 'SHOW CLUSTER'
    when /sysgen/i    then 'SYSGEN'
    when /sysmanhel/i then 'MCR SYSMAN'
    when /sysmsghel/i then 'System Messages'
    when /teco/i      then 'TECO'
    when /tff\$tfuh/i then 'Terminal Fallback Facility'
    when /tpuhelp/i   then 'VAXTPU'
    when /uafhelp/i   then 'AUTHORIZE' #'UAF'
    when /vmstlrhlp/i then 'VMS Tailoring Facility'
    when /^wp/i       then 'Watchpoint Utility'
  # unbundled
    # C has textlibs
    # Common Data Dictionary
    when /^acl/i      then 'CDD/Plus ACL'
    when /cddlhelp/i  then 'CDD/Plus Dictionary Data Definition Language Utility'
    when /cddv/i      then 'CDD/Plus Dictionary Verify/Fix Utility'
    when /cdo\$help/i then 'CDD/Plus CDO'
    when /^dmu$/i     then 'CDD/Plus Dictionary Management Utility'
    when /rpc\$swlu/i then 'CDD/Plus RPCSWLUP'
    # COBOL
    when /cobolhlp/i  then 'COBOL'
    # DECnet SNA Gateway
    when /snancphel/i then 'DECnet SNA Gateway NCP'
    when /snatrace/i  then 'DECnet SNA Gateway TRACE'
    # FORTRAN has textlibs
    # LISP
    when /dclhelp/i   then 'LISP' # REVIEW conflicts?
    # LSE
    when /lse\$keyp/i then 'Language Sensitive Editor Keypad'
    when /lsd\$menu/i then 'Language Sensitive Editor Menu'
    when /lsehelp/i   then 'Language Sensitive Editor'
    # Pascal has textlibs
    # PCSA Server
    when /pcsa_mana/i then 'Services for PCs Manager'
    # RDB
    when /rdohelp/i   then 'RDB/VMS Relational Database Operator' # also CDD
    when /rmualter/i  then 'RDB/VMS RMU/ALTER'
    when /rmudispla/i then 'RDB/VMS RMU/SHOW'
    when /sql\$help/i then 'RDB/VMS SQL'
    # UCX
    when /ucx\$ftp_/i then 'UCX FTP'
    when /ucx\$teln/i then 'UCX TELNET'
    when /ucx\$ucp_/i then 'UCX NFS (UCP)'
    # VWS
    when /uishelp/i   then 'VAX Workstation Software (UIS)'
  # thirdparty
    when /2020/i      then 'Access Technology 20/20'
    when /386ware/i   then 'LogiCraft 386ware'
    when /imprint/i   then 'Northlake Software IMPRINT'
    when /xxtoxx/i    then 'Northlake Software IMPRINT Font Translation Utilities'
    when /fsinstall/i then 'SAS System Installation'
    when /sashelp/i   then 'SAS System'
    when /^status/i   then 'Sybase Data Workbench STATUS'
    when /wandsh/i    then 'Sybase Data Workbench WAND Extended Workstation Routines'
    when /wanduh/i    then 'Sybase Data Workbench WAND User Routines'
    when /wandwh/i    then 'Sybase Data Workbench WAND Workstation Routines'
    when /^finger/i   then 'CMU IP FINGER'
    when /^ftp/i      then 'CMU IP FTP'
    when /^ftpcmd/i   then 'CMU IP FTP Commands'
    when /^hostnm/i   then 'CMU IP HOSTNAME'
    when /^netexit/i  then 'CMU IP NETEXIT'
    when /^netlog/i   then 'CMU IP NETLOG'
    when /^netstat/i  then 'CMU IP NETSTAT'
    when /^smail/i    then 'CMU IP SENDMAIL'
    when /^telnet/i   then 'CMU IP TELNET'
    when /^kermit_c/i then 'KERMIT Commands'
    when /^kermit/i   then 'KERMIT'
    when /^mailbox/i  then 'MAILBOX' # REVIEW
    # TODO some more Sybase help libraries to extract (incorrectly named .HLP?)
    else hlb.tap { |h| warn "no name translation available for help library #{h.inspect}" }
    end
  end
end

module MicroVMS
  def self.extended(k)
    k.extend VMS
  end
end

module OpenVMS
  def self.extended(k)
    k.extend VMS
  end
end

class VMSHelpLibrary
  attr_reader :name, :modules
  def initialize(name, helptext)
    @name = name # REVIEW is this useful
    @modules = []

    modname = ''
    modtext = []
    helptext.lines.each do |line|
      #warn "tab encountered: #{line.inspect}" if line.include? "\t" # REVIEW if we switch from ::Nroff
      case line
      when /^!/ then next # is comment
      when /^1\s+(\S.*)$/ # new module key
        @modules << VMSHelpLibraryModule.new(1, modname, modtext)
        modname = Regexp.last_match[1]
        modtext = []
      else modtext << line
      end
    end
    @modules << VMSHelpLibraryModule.new(1, modname, modtext)
  end

  def subsections
    @modules.select { |mod| mod.name.match? /[a-z]/ }
  end

  def commands
    @modules.reject { |mod| mod.name.match? /[a-z]/ }
  end
end

class VMSHelpLibraryModule
  attr_reader :depth, :text

  def initialize(depth, name, helptext)
    #warn "#{'   ' * (depth-1)}new: #{depth} #{name}"
    @name = name.strip # occasionally will get trailing whitespace that messes up the anchors
    @depth = depth
    @subsections = []
    @text = []

    newname = ''
    modtext = []
    helptext.each do |line|
      case line
      #when /^#{@depth+1}\s+(\S.*)$/, /^(\/\S.*)/ # new submodule key or qualifier
      when /^#{@depth+1}\s+(\S.*)$/ # new submodule key
        @subsections << VMSHelpLibraryModule.new(@depth+1, newname, modtext) unless newname.empty?
        newname = Regexp.last_match[1]
        modtext = []
      else (newname.empty? ? @text : modtext) << line
      end
    end
    @subsections << VMSHelpLibraryModule.new(@depth+1, newname, modtext) unless newname.empty?

    # qualifiers
    newname = ''
    modtext = @text
    @text = []
    modtext.each do |line|
      case line
      when /^(\/\S.*)/ # new qualifier
        @subsections << VMSHelpLibraryModule.new(@depth+1, newname, modtext) unless newname.empty?
        newname = Regexp.last_match[1]
        modtext = []
      else (newname.empty? ? @text : modtext) << line
      end
    end
    @subsections << VMSHelpLibraryModule.new(@depth+1, newname, modtext) unless newname.empty?
  end

  def name
    subsection? ? @name.tr('_', ' ') : @name
  end

  def linkname
    # REVIEW add : to characters to split after? see µ4.4 DEBUG DEPOSIT/ASCII:n
    qualifier? ? @name.sub(/^(\/.+?)[= \[].*$/, '\1') : name # might get something like /[NO]TERMINATE
  end

  def qualifier?
    @name.start_with?('/')
  end

  def subsection?
    !qualifier? and @name.match?(/[a-z]/)
  end

  def command?
    !subsection? and !qualifier?
  end

  def qualifiers
    @subsections.select(&:qualifier?)
  end

  def subsections
    @subsections.select(&:subsection?)
  end

  def commands
    @subsections.select(&:command?)
  end

  def all_subsections
    @subsections
  end
end
