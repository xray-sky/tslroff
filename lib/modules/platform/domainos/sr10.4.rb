# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/04/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# Domain/OS SR10.4 Platform Overrides
#
# TODO:
#  bsd  sigstack(2) missing see also heading => sigvec(2), setjmp(3)
#  sysv arp(1m) see also inet( ), arp( )
#  sysv audit(1m) see also audit_report, audit_demom
#  sysv audit_daemon(1m) see also audit, audit_report
#  sysv audit_report(1m) see also audit, audit_daemon
#  sysv lcnode(1m) see also help lcnet
#  sysv netsvc(1m) see also help rtsvc
#  sysv nrglbd(1m) see also glbd, lb_admin, llbd
#  sysv rpcd(1m) see also llbd, rpccp
#  sysv spm(1m) see also spm
#  sysv stlicense(1m) see also linking title
#  sysv uuid_gen(1m) see also uuidgen
#  sysv uuidgen(1m) see also uuid_gen
#

module DomainOS_SR10_4

  def self.extended(k)
    case k.instance_variable_get '@input_filename'
    when 'index.hlp'
      k.instance_variable_set '@manual_entry', '_index'
    when 'coffdump.1'
      k.define_singleton_method(:detect_links, k.method(:detect_links_sysv_coffdump)) if k.instance_variable_get('@source_dir').include? 'sys5'
    when 'edacl.hlp'
      k.instance_variable_set '@heading_detection', %r{^(?<section>[A-Z][A-Za-z0-9\s]+)$}
      k.instance_variable_set '@related_info_heading', 'SEE ALS0'
    when 'cdfsmount.1m', 'cdfsumount.1m'
      k.instance_variable_set '@related_info_heading', 'SEE AlSO'
    when 'bitmap.1', 'hpvue2.1', 'mkfontdir.1', 'mwm.1', 'resize.1', 'vuewm.1',
         'xclock.1', 'xfd.1', 'xhost.1', 'xinit.1', 'xload.1', 'xlsfonts.1', 'xmodmap.1',
         'xpr.1', 'xrdb.1', 'xrefresh.1', 'xset.1', 'xsetroot.1', 'xterm.1', 'xwd.1',
         'xwininfo.1', 'xwud.1', 'vuewmrc.4', 'xterm.5', 'xterm.7'
      k.instance_variable_set '@base_indent', 6
      k.instance_variable_set '@heading_detection', %r{^\s(?<section>[A-Z][A-Za-z0-9\s]+)$}
    when 'cu.1c',
         'accept.1m', 'captoinfo.1m', 'ftpd.1m', 'rc.1m', 'reject.1m', 'rexecd.1m',
         'uuclean.1m', 'uucleanup.1m', 'writed.1m',
         'vhangup.2'
      # captoinfo.1m title detection fails due to broken title, but ends up where it ought to go anyway
      k.define_singleton_method :detect_links, k.method(:detect_links_rcs)
    when 'stlicense.1', 'stload.1'
      k.instance_variable_set '@lines_per_page', 66
      k.define_singleton_method :detect_links, k.method(:detect_links_rcs)
    when 'vuecommand.1', 'vuefile.1', 'vuehello.1', 'vuepad.1', 'vuesession.1', 'vuestyle.1'
      k.instance_variable_set '@lines_per_page', 66
      k.instance_variable_set '@related_info_heading', 'RELATED INFORMATION'
    when 'vuehelp.1', 'vuelogin.1'
      k.instance_variable_set '@lines_per_page', 66
      k.instance_variable_set '@related_info_heading', 'RELATED INFORMATION'
    when 'ali.n', 'anno.n', 'burst.n', 'comp.n', 'dist.n'
      k.instance_variable_set '@systype', 'bsd'
    when 'ci.n', 'co.n', 'ident.n', 'merge.n', /^rcs.*\.n$/, 'rlog.n', 'sccstorcs.n'
      k.define_singleton_method :detect_links, k.method(:detect_links_rcs)
      # TODO: links spanning lines - rcsfile.n "rcsmerge (1)"
      #                              rcs.n     "rlog (1)"
      #                              ident.n   "rcsmerge (1)"
      #                              rlog.n    "rcsintro (1)"
    when 'cc.hlp', 'clxwedlisp.hlp', 'ftn.hlp', 'lisp.hlp', 'pas.hlp', 'wedlisp.hlp'
      raise ManualIsBlacklisted, 'is unbundled'
    when 'Imakefile.3X11', 'Makefile.3X11'
      raise ManualIsBlacklisted, 'is makefile'
    end
  end

  def page_title
    super << " Domain/OS SR10.4"
  end

end
