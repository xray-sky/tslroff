# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 07/7/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# UC Berkeley 386BSD Platform Overrides
#
# TODO
#   magic (garbage in garbage out)
#   see also for "man1ext" (eqn, groff, grotty, etc.): not detecting, sections need repointed,
#      maybe we can skip linking to man[57]ext as we haven't these pages
#   all of the troff sources (local, x386)
#   what is going on with the XFree86 pages? also bison(1), others?
#   1.0 - cc(1) has page breaks
#
# REVIEW
#   are the section 0 pages even "enabled"? or were they moved there to "disable" them
#   is this for UCB 386BSD? or for Walnut Creek 386BSD?? I think the Nroff is for the latter;
#     the former seems to have Troff (Groff?)
#

module X386BSD
  class Troff < Troff::Man  # REVIEW probably actually Groff (e.g. groff_char(7))
    def initialize source
      @manual_entry ||= source.file.sub(/\.(?:[\dZz]\S?)$/, '')
      super source
    end
  end

  class Nroff < Nroff

    def initialize source
      @manual_entry ||= source.file.sub(/\.(?:[\dZz]\S?)$/, '')
      @heading_detection ||= %r(^\s{5}(?<section>[A-Z][A-Za-z\s]+)$)
      @title_detection ||= %r{^\s+(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))\s.+?\s\k<manentry>$}
      @related_info_heading ||= 'SEE ALSO'

      super source

      @lines_per_page = nil
      case @source.file
      when 'uniq.0', 'whois.0' then define_singleton_method :parse_title_degenerate, method(:parse_title)
      when 'as.0', 'cc.0', 'ci.0', 'co.0', 'cpio.0', 'ed.0', 'elvis.0', 'elvispreserve.0', 'eqn.0', 'groff.0',
           'grops.0', 'grotty.0', 'ident.0', 'join.0', 'ld.0', 'math.0', 'me.0', 'merge.0', 'mille.0', 'more.0',
           'pic.0', 'pr.0', 'rcs.0', 'rcsclean.0', 'rcsdiff.0', 'rcsfile.0', 'rcsfreeze.0', 'rcsintro.0', 'rcsmerge.0',
           'rlog.0', 'rogue.0', 'sh.0', 'sort.0', 'tail.0', 'tbl.0', 'tcpdump.0'
        @lines_per_page = 66
      end
    end

    def parse_title
      title = super
      @manual_section = case @manual_section
                        when ''          then '1'
                        when '@man1ext@' then '1ext'
                        when 'gnu'       then '6'
                        else @manual_section
                        end
      #@output_directory = "man#{@manual_section}"
      title
    end

    def parse_title_degenerate
      @manual_section   = '1'
      #@output_directory = "man#{@manual_section}"
      true
    end

  end
end
