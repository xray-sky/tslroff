# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/07/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# Domain/OS SR10.4.1 Platform Overrides
#
# Mostly identical to SR10.4.
# Primary differences are in the X11 manual. Couple others.
# Most (if not all) overrides from SR10.4 should be mirrored here,
# unless I can find a reasonable way to subsume them directly.
#
# TODO: bsd crddf.1 is in help format
#       ali.n [3]: .so can't read .//usr/new/lib/mh/tmac.h
#

class DomainOS::SR10_4_1
  class Nroff < ::DomainOS::Nroff

    def initialize(source)
      case source.file
      when 'index.hlp'
        @manual_entry = '_index'
      when 'edacl.hlp'
        @heading_detection = %r{^(?<section>[A-Z][A-Za-z0-9\s]+)$}
        @related_info_heading = 'SEE ALS0'
      when 'coffdump.1'
        define_singleton_method(:detect_links, method(:detect_links_sysv_coffdump)) if source.dir.include? 'sys5'
      when 'mkfontdir.1.05.30', 'crypt.1', 'makekey.1' # problem here wanting to do more about mkfontdir filename
        @base_indent = 6
        @heading_detection = %r{^\s(?<section>[A-Z][A-Za-z0-9\s]+)$}
      when 'ali.n', 'anno.n', 'burst.n', 'comp.n', 'dist.n'
        @systype = 'bsd'
        @manual_entry = "#{@manual_entry}.bsd"
      when 'ci.n', 'co.n', 'ident.n', 'merge.n', /^rcs.*\.n$/, 'rlog.n', 'sccstorcs.n'
        define_singleton_method :detect_links, method(:detect_links_rcs)
        # TODO: links spanning lines - rcsfile.n "rcsmerge (1)"
        #                              rcs.n     "rlog (1)"
        #                              ident.n   "rcsmerge (1)"
        #                              rlog.n    "rcsintro (1)"
      when 'cc.hlp', 'clxwedlisp.hlp', 'ftn.hlp', 'lisp.hlp', 'pas.hlp', 'wedlisp.hlp'
        raise ManualIsBlacklisted, 'is unbundled'
      when 'Imakefile.3X11', 'Makefile.3X11'
        raise ManualIsBlacklisted, 'is makefile'
      end

      super(source)
    end

    def page_title
      super << " Domain/OS SR10.4.1"
    end

  end
end
