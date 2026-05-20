# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/24/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Data General DG/UX Platform Overrides
#
# Some of the page titles don't match the pattern "man(sec)   something   man(sec)"
#                                 but instead are "something              man(sec)"
#        and a couple with super long names match "maaaaaaaaaaan(smaaaaaaaaan(sec)"
# - but with backspaces are they looking ok? perhaps not or I'd get type clashes?
#
# (5.4.2) still linking header line when see also spans page breaks
#
# REVIEW how did I end up with a bunch of zero length .z files in 5.4R3.00 ?
#

module DG_UX
  class Source < Source
    def initialize(file, **kwargs, &block)
      kwargs[:encoding] ||= Encoding::ISO_8859_1
      super(file, **kwargs, &block)
    end
  end

  class Nroff < Nroff
    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.(?:\d\S?)\.g?[zZ]$/, '')
      @heading_detection ||= %r(^(?<section>[A-Z][A-Za-z\s]+)$)
      @title_detection ||= %r{\s(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))$}
      super(source, **kwargs)
    end
  end

  def self.name_for_section(sec)
    case sec.downcase
    when '0'    then "<strong>#{sec}.</strong> Preface"
    when '1'    then "<strong>#{sec}.</strong> Commands"
    when '1c'   then "<strong>#{sec}.</strong> Communication Commands"
    when '1g'   then "<strong>#{sec}.</strong> Graphics Commands"
    when '1m'   then "<strong>#{sec}.</strong> Maintenance Commands"
    when '1x'   then "<strong>#{sec}.</strong> Motif Commands"
    when '2'    then "<strong>#{sec}.</strong> System Calls"
    when '3'    then "<strong>#{sec}.</strong> Subroutines and Libraries"
    when '3c'   then "<strong>#{sec}.</strong> C Library"
    when '3e'   then "<strong>#{sec}.</strong> ELF Library"
    when '3g'   then "<strong>#{sec}.</strong> General Purpose Library"
    when '3k'   then "<strong>#{sec}.</strong> Kernel Programming Routines"
    when '3m'   then "<strong>#{sec}.</strong> Math Library"
    when '3n'   then "<strong>#{sec}.</strong> Network Support Libraries"
    when '3r'   then "<strong>#{sec}.</strong> RPC Functions"
    when '3s'   then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3t'   then "<strong>#{sec}.</strong> pthreads Library" # TODO Trusted Computing for Trusted extension
    when '3w'   then "<strong>#{sec}.</strong> Multinational Language Set (MNLS) Functions"
    when '3x'   then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '3x11' then "<strong>#{sec}.</strong> X11 Library"
    when '3xt'  then "<strong>#{sec}.</strong> X Toolkit"
    when '4'    then "<strong>#{sec}.</strong> File Formats"
    when '4m'   then "<strong>#{sec}.</strong> File Formats"
    when '5'    then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '5x'   then "<strong>#{sec}.</strong> Miscellaneous X11 Facilities"
    when '6'    then "<strong>#{sec}.</strong> Networking Facilities"
    when '6f'   then "<strong>#{sec}.</strong> Protocol Families"
    when '6m'   then "<strong>#{sec}.</strong> Trusted Networking"
    when '6p'   then "<strong>#{sec}.</strong> Network Protocols"
    when '7'    then "<strong>#{sec}.</strong> Special Files"
    when '8'    then "<strong>#{sec}.</strong> Maintenance Procedures"
    else "Section #{sec}"
    end
  end
end


