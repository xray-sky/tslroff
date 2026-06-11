# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/04/23.
# Copyright 2023 Typewritten Software. All rights reserved.
#
#
# VMS Platform Overrides
#

require_relative 'helplib'
require_relative 'helplibmod'

module VMS
  class Help < VMS::Nroff

    include Troff::Tab  # for laying out TOC links

    @@webdriver = nil
    def self.webdriver ; @@webdriver ; end

    def initialize(source, **kwargs)
      @@webdriver ||= WebDriver.new backing_store: ENV['WEBDRIVER_CACHE'] # cache doesn't help us REVIEW maybe it does, if persisted; that's a lot of chrome cpu
      @@pixels_per_inch ||= @@webdriver.ppi
      @manual_entry = source.file.sub(/\.(?:hl|tx).$/, '')
      @manual_section = 'Subsystem Help' unless @manual_entry == 'helplib'
      @helplib_dir = source.file.sub(/(?:hlp|txt)$/, 'hlb')
      @helplib = @manual_entry.dup
      @tabstops = [6, 12, 18, 24, 30, 36] # 1i 2i 3i 4i 5i 6i (in em - 6 per i at 12pt)

      super(source, **kwargs)

      @lines_per_page = nil
    end

    def to_html(**kwargs)
      return if kwargs.any?

      hlb = HelpLibrary.new(hlbname(@manual_entry), @source)
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

      #hlb.commands.each do |mod|
      #  pid = fork
      #  if pid
      #    Process.waitpid(pid)
      #  else
      #    @manual_entry = mod.name
      #    pagehead = Block::Header.new(text: Text.new(text: "#{helplib} #{mod.name} &mdash; #{@platform} #{@version}"))
      #    pagelinks = {commands: [], qualifiers: [], subsections: []}
      #    pagetext = mod_to_html mod
      #    break
      #  end
      #end

      #"#{pagehead.to_html}#{format_links(pagelinks)}#{pagetext}#{pagefoot}"

      [[ @manual_entry, "#{pagehead.to_html}#{format_links(pagelinks)}#{pagetext}#{pagefoot}" ]] +
      hlb.commands.collect do |mod|
        #pid = fork
        #if pid
        #  Process.waitpid(pid)
        #else
          #@manual_entry = mod.name
          pagehead = Block::Header.new(text: Text.new(text: "#{helplib} #{mod.name} &mdash; #{@platform} #{@version}"))
          pagelinks = {commands: [], qualifiers: [], subsections: []}
          pagetext = mod_to_html mod
        #  break
        #end
        [ "#{@helplib_dir}/#{mod.name}", "#{pagehead.to_html}#{format_links(pagelinks)}#{pagetext}#{pagefoot}" ]
      end

      #"#{pagehead.to_html}#{format_links(pagelinks)}#{pagetext}#{pagefoot}"
    end

    # we'll work directly in em to avoid needing to include a cascade of Troff methods
    # add a 1em over-width to keep text from running together
    def typesetter_width(fragment)
      1.0 + 6 * @@webdriver.width(fragment) / @@pixels_per_inch # em @ 12pt
    end

    def output_directory
      @manual_entry == @helplib ? '' : @helplib_dir
    end

    def page_title
      "#{@manual_entry} #&mdash; #{@platform} #{@version}"
    end

    def index_name
      @manual_entry
    end

    def index_description
      hlbname(@manual_entry)
    end

    protected

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
            insert_tab(width: (stop - @current_block.last_tab_position), stop: stop)
          else
            @current_block << LineBreak.new
          end
        end
        @current_block.empty? ? Block::Bare.new : @current_block
      end.collect(&:to_html).join
      links.empty? ? '' : "#{heading.to_html}#{links}"
    end

    def mod_to_html(mod, h1: false)
      # TODO increase heading level of qualifiers by one (...probably?)
      #        ==> counterargument: exchnghlp (qualifiers are not subheads of Description)
      #            maybe only do this if we are children of a section named "Qualifiers"?
      # TODO get qualifier alts in heading (all lines starting with / until first that doesn't);
      #      can separate with <br /> for intended effect -- see µVMS 4.6 helplib e.g. /LIBRARY/HELP
      depth = mod.depth
      pagelinks = {}
      modulehead = ''
      modulehead = %(<a name="#{mod.linkname}"><h#{depth}>#{mod.name}</h#{depth}></a>) if h1 or depth>1
      moduletext = (@source = Source.new(nil, magic: :Nroff) { mod.text } ; to_lp.collect(&:to_html).join)
      subsectiontext = mod.all_subsections.collect { |s| mod_to_html s }.join
      pagelinks[:subsections] = mod.subsections.collect { |s| Block::Link.new(text: Text.new(text: s.name), href: "##{s.name}") }
      pagelinks[:qualifiers] = mod.qualifiers.collect { |q| Block::Link.new(text: Text.new(text: q.linkname), href: "##{q.linkname}") }
      pagelinks[:commands] = mod.commands.collect do |c|
        next if c.name.strip.empty? # REVIEW maybe this should be done in the detector method
        Block::Link.new(text: Text.new(text: c.name), href: "##{c.name}")
      end
      "#{modulehead}#{moduletext}#{format_links(pagelinks)}#{subsectiontext}"
    end

    def hlbname(hlb)
      case hlb
      when /acledt/i    then 'ACL Editor' # REVIEW
      when /anlrmshlp/i then 'ANALYZE/RMS_FILE'
      when /analaudit/i then 'ANALYZE/AUDIT'
      when /cafhelp/i   then 'CLUSTER_AUTHORIZE'
      when /debughlp/i  then 'DEBUG'
      when /dbg\$help/i then 'DEBUG'
      when /dbg\$dwhe/i then 'DEBUG (DECwindows)'
      when /ddif\$vie/i then 'DECwindows CDA Viewer'
      when /decw\$vue/i then 'DECwindows FileView'
      when /decw\$(.+)/i then "DECwindows (#{Regexp.last_match[1]})"
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
      when /fortran\$dw/i then 'DECwindows Compiler Interface for FORTRAN'
      when /helplib/i   then 'HELP'
      when /instalhlp/i then 'INSTALL'
      when /latcp/i     then 'LATCP'
      when /lmcp\$hlb/i then 'LMCP' # Log Manager Control Program
      when /macro\$dw/i then 'DECwindows Compiler Interface for MACRO'
      when /mailhelp/i  then 'MAIL'
      when /mnrhelp/i   then 'MONITOR'
      when /ncphelp/i   then 'DECnet NCP'
      when /pascal\$dwc/i then 'DECwindows Compiler Interface for Pascal'
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
      when /lisp\$dec/i then 'LISP DECwindows Development Environment'
      # LSE
      when /lse\$keyp/i then 'Language Sensitive Editor Keypad'
      when /lse\$menu/i then 'Language Sensitive Editor Menu'
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
end
