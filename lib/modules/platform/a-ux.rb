# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/28/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Apple A/UX Platform Overrides
#
# 0.7 postscript(7), pscatmap(8), transcript(8), etc. is troff source
# 2.0 some pages got sections in their names - autorecovery.8.html, etc.
#     - these do not end with .z - this is fixed now but leaving the note to think harder about being more generic
# 2.0 esch(8) sees-also "Startup-^MShell(8)" (with line break)
#
# local .TH for 0.7 transcript, if we have tmac.an
#

module A_UX
  class Nroff < Nroff

    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.(?:\d\S?)(?:\.[zZ])?$/, '') # REVIEW: would this be better & more generic as a 'scan' call? everything after the section?
      @heading_detection ||= %r(^\s{5}(?<section>[A-Z][A-Za-z\s]+)$)
      @title_detection ||= %r{^\s{5}(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))\s.+?\s\k<manentry>$}
      super(source, **kwargs)
    end

    def page_title
      "#{@manual_entry}(#{@manual_section}) &mdash; A/UX #{@version}"
    end
  end

  def self.name_for_section(sec)
    case sec.downcase
    when '1'   then "<strong>#{sec}.</strong> Commands"
    when '1c'  then "<strong>#{sec}.</strong> Communications Commands"
    when '1g'  then "<strong>#{sec}.</strong> Graphics Commands"
    when '1m'  then "<strong>#{sec}.</strong> Maintenance Commands"
    when '1n'  then "<strong>#{sec}.</strong> Network Commands"
    when '1x'  then "<strong>#{sec}.</strong> X11 Commands"
    when '2'   then "<strong>#{sec}.</strong> System Calls"
    when '2n'  then "<strong>#{sec}.</strong> Socket Library"
    when '2p'  then "<strong>#{sec}.</strong> POSIX System Calls"
    when '3'   then "<strong>#{sec}.</strong> Subroutines and Libraries"
    when '3c'  then "<strong>#{sec}.</strong> C Library"
    when '3f'  then "<strong>#{sec}.</strong> FORTRAN Library"
    when '3m'  then "<strong>#{sec}.</strong> Math Library"
    when '3n'  then "<strong>#{sec}.</strong> Network Support Library"
    when '3p'  then "<strong>#{sec}.</strong> POSIX Compatibility Routines"
    when '3s'  then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3x'  then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '3xt' then "<strong>#{sec}.</strong> X Toolkit"
    when '4'   then "<strong>#{sec}.</strong> File Formats"
    when '4n'  then "<strong>#{sec}.</strong> Networking File Formats"
    when '5'   then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '5p'  then "<strong>#{sec}.</strong> Network Protocols"
    when '6'   then "<strong>#{sec}.</strong> Games"
    when '7'   then "<strong>#{sec}.</strong> Special Files"
    when '7n'  then "<strong>#{sec}.</strong> Network Special Files"
    when '7p'  then "<strong>#{sec}.</strong> POSIX Special Files"
    when '8'   then "<strong>#{sec}.</strong> Maintenance Procedures"
    else "Section #{sec}"
    end
  end

end
