# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/30/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# Domain/OS SR10.3.5 Platform Overrides
#
# TODO:
#  sysv arp(1m) see also inet( ), arp( )
#  sysv audit(1m) see also audit_report, audit_demom
#  sysv audit_daemon(1m) see also audit, audit_report
#  sysv audit_report(1m) see also audit, audit_daemon
#  sysv lcnode(1m) see also help lcnet
#  sysv netsvc(1m) see also help rtsvc
#  sysv spm(1m) see also shutspm, mbx_helper
#  sysv stlicense(1m) see also linking title
#  X11  Xdomain(1) links 404 to non-systype
#

module DomainOS
  module SR10_3_5
    class Source < Source
      def initialize(file, **kwargs, &block)
        case File.basename file
        when 'cc.hlp', 'clxwedlisp.hlp', 'dpcc.hlp', 'dpcc_remote.hlp', 'ftn.hlp',
             'lisp.hlp', 'pas.hlp', 'wedlisp.hlp'
          raise ManualIsBlacklisted, 'is unbundled'
        when 'Imakefile.3X11', 'Makefile.3X11'
          raise ManualIsBlacklisted, 'is makefile'
        end
        super(file, **kwargs, &block)
      end
    end

    class Manual < Manual ; end
    class Help < Help ; end
    class Nroff < Nroff
      def initialize(source, **kwargs)
        super(source, **kwargs)

        case @source.file
        when 'coffdump.1'
          define_singleton_method(:detect_links, method(:detect_links_sysv_coffdump)) if source.dir.include? 'sys5'
        when 'edacl.hlp'
          @heading_detection = %r{^(?<section>[A-Z][A-Za-z0-9\s]+)$}
          @related_info_heading = 'SEE ALS0'
        when 'cdfsmount.1m', 'cdfsumount.1m'
          @related_info_heading = 'SEE AlSO'
        when 'Xdomain.1', 'mwm.1', 'stconv.1', 'stload.1', 'stmkdirs.1', 'stmkfont.1', 'x11start.1'
          @lines_per_page = 66
        when 'stlicense.1'
          @lines_per_page = 66
          define_singleton_method :detect_links, method(:detect_links_rcs)
        when 'cu.1c',
             'accept.1m', 'captoinfo.1m', 'ftpd.1m', 'rc.1m', 'reject.1m', 'rexecd.1m',
             'uuclean.1m', 'uucleanup.1m', 'writed.1m',
             'vhangup.2'
          # captoinfo.1m title detection fails due to broken title, but ends up where it ought to go anyway
          define_singleton_method :detect_links, method(:detect_links_rcs)
        when 'ci.n', 'co.n', 'ident.n', 'merge.n', /^rcs.*\.n$/, 'rlog.n', 'sccstorcs.n'
          define_singleton_method :detect_links, method(:detect_links_rcs)
          # TODO: links spanning lines - rcsfile.n "rcsmerge (1)"
          #                              rcs.n     "rlog (1)"
          #                              ident.n   "rcsmerge (1)"
          #                              rlog.n    "rcsintro (1)"
        when 'ali.n', 'anno.n', 'burst.n', 'comp.n', 'dist.n'
          @systype = 'bsd'
        end
      end

      def page_title
        super << " Domain/OS SR10.3.5"
      end
    end

    def self.name_for_section(sec)
      case sec.downcase
      when '1m' then "<strong>#{sec}.</strong> Maintenance Commands (SysV)"
      when '3'  then "<strong>#{sec}.</strong> C Library"
      when '3c' then "<strong>#{sec}.</strong> Compatibility Routines"
      when '5'  then "<strong>#{sec}.</strong> File Formats (4BSD) &amp; Miscellaneous Facilities (SysV)"
      when '7'  then "<strong>#{sec}.</strong> Miscellaneous Facilities (4BSD) &amp; Special Files (SysV)"
      when '8'  then "<strong>#{sec}.</strong> Maintenance Procedures (4BSD)"
      when '8c' then "<strong>#{sec}.</strong> Network Services (4BSD)"
      else Aegis.name_for_section(sec)
      end
    end
  end
end
