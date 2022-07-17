# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 07/7/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# UC Berkeley 386BSD Platform Overrides
#
# TODO:
#  magic (garbage in garbage out)
#  see also for "man1ext" (eqn, groff, grotty, etc.): not detecting, sections need repointed,
#      maybe we can skip linking to man[57]ext as we haven't these pages
#  all of the troff sources (local, x386)
#
#

module X386BSD

  def self.extended(k)
    k.instance_variable_set '@manual_entry',
      k.instance_variable_get('@input_filename').sub(/\.([\dZz]\S?)$/, '')
    k.instance_variable_set '@heading_detection', %r(^(?<section>[A-Z][A-Za-z\s]+)$)
    k.instance_variable_set '@related_info_heading', 'SEE ALSO'
    k.instance_variable_set '@lines_per_page', nil
    case k.instance_variable_get '@input_filename'
    when 'index.0'
      k.instance_variable_set '@manual_entry', '_index'
    when 'uniq.0', 'whois.0'
      k.define_singleton_method :parse_title, k.method(:parse_title_degenerate)
    when 'ci.0', 'co.0', 'cpio.0', 'ident.0', 'join.0', 'merge.0', 'pr.0', 'rcs.0',
         'as.0', 'cc.0', 'ld.0', 'sh.0', 'tcpdump.0',
         'rcsclean.0', 'rcsdiff.0', 'rcsfreeze.0', 'rcsintro.0', 'rcsmerge.0', 'rlog.0',
         'sort.0', 'tail.0', 'math.0', 'rcsfile.0', 'mille.0', 'rogue.0', 'me.0',
         'ed.0', 'elvis.0', 'elvispreserve.0', 'more.0',
         'eqn.0', 'groff.0', 'grops.0', 'grotty.0', 'pic.0', 'tbl.0'
      k.instance_variable_set '@lines_per_page', 66
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
    @output_directory = "man#{@manual_section}"
    title
  end

  def parse_title_degenerate
    @manual_section   = '1'
    @output_directory = "man#{@manual_section}"
    true
  end
end


