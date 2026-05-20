# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/23/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# SCO OpenDesktop Platform Overrides
#
# TODO
#   losing capital letters in command names (e.g. Xsco) from output files
#

module OpenDesktop
  class Manual < Manual ; end
  class Nroff < Nroff

    def initialize(source, **kwargs)
      #@manual_entry ||= source.file.sub(/(?:_bsd|_.+fs|_s5|_xnx)?\.(?:[\dZz]\S?)$/, '')
      @manual_entry ||= source.file.sub(/\.(?:[A-Z]+)\.?[zZ]?$/, '')
      @heading_detection ||= %r(^\s(?<section>[A-Z][A-Za-z\s]+)$)
      @title_detection ||= %r{^\s(?<manentry>(?<cmd>\S+?)\((?<section>[A-Z]+)\))\s+}
      @related_info_heading ||= 'See also'
      super(source, **kwargs)
      @lines_per_page = nil
    end

    def parse_title
      title = get_title or warn "reached end of document without finding title!"
      return unless title
      @manual_entry     = title[:cmd].downcase # this is where I'm losing capital letters... philosophical conflict between all caps title and truncated filename
      @manual_section   = title[:section]
      title
    end

    # SCO uses alphabetic section names
    def detect_links(line)
      # make sure we break detection on space or punctuation, in order to correctly
      line.scan(/(?<=[\s,.;])((\S+?)\(([A-Z]+?)\))/).map do |text, ref, section|
        [text, "../man#{section}/#{ref}.html"]
      end.to_h
    end

    def output_directory
      @manual_section and return "man#{@manual_section}"
      super
    end

  end

  def self.name_for_section(sec)
    case sec.downcase
    when '1'    then "<strong>#{sec}.</strong> X11 Commands"
    when '1m'   then "<strong>#{sec}.</strong> Maintenance Commands" # VxVM
    when 'adm'  then "<strong>#{sec}.</strong> System Administration Commands"
    when 'admn' then "<strong>#{sec}.</strong> Network Administration Commands"
    when 'admp' then "<strong>#{sec}.</strong> Special Files and Protocols"
    when 'c'    then "<strong>#{sec}.</strong> Commands"
    when 'cmd'  then "<strong>#{sec}.</strong> DOS Commands"
    when 'cp'   then "<strong>#{sec}.</strong> Programming Commands"
    when 'ct'   then "<strong>#{sec}.</strong> Text Processing Commands"
    when 'dos'  then "<strong>#{sec}.</strong> DOS Commands"
    when 'f'    then "<strong>#{sec}.</strong> File Formats"
    when 'hw'   then "<strong>#{sec}.</strong> Hardware-dependent Features and Files"
    when 'lm'   then "<strong>#{sec}.</strong> LAN Manager Commands and Files"
    when 'm'    then "<strong>#{sec}.</strong> Miscellaneous Features and File Formats"
    when 'n'    then "<strong>#{sec}.</strong> ONC Operation and Maintenance Commands"
    when 'nc'   then "<strong>#{sec}.</strong> ONC Commands"
    when 'nf'   then "<strong>#{sec}.</strong> ONC File Formats"
    when 'padm' then "<strong>#{sec}.</strong> IPX Operation and Maintenance Commands"
    when 'sff'  then "<strong>#{sec}.</strong> Network File Formats"
    when 'tc'   then "<strong>#{sec}.</strong> TCP/IP Commands"
    when 'x'    then "<strong>#{sec}.</strong> X11 Commands"
# SDS pages - TODO parse correctly!
    when 's'    then "<strong>#{sec}.</strong> System Services and Library Routines"
    when 'xm'   then "<strong>#{sec}.</strong> Motif Library"
    when 'xs'   then "<strong>#{sec}.</strong> X11 Library"
    when 'xt'   then "<strong>#{sec}.</strong> X Toolkit"
    else "Section #{sec}"
    end
  end
end

# module alias
SCO_SysV386 = OpenDesktop
