# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/2/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# mips RISC/os Platform Overrides
#

require_relative 'modules/risc-os/nroff'
require_relative 'modules/risc-os/troff'
require_relative 'modules/risc-os_4.52'
require_relative 'modules/risc-os_5.01'

module RISC_os

  def self.name_for_section(sec)
    case sec.downcase
    when '1'     then "<strong>#{sec}.</strong> Commands"
    when '1c'    then "<strong>#{sec}.</strong> Communications Commands"
    when '1g'    then "<strong>#{sec}.</strong> Graphics Commands"
    when '1m'    then "<strong>#{sec}.</strong> Maintenance Commands"
    when '1mspp' then "<strong>#{sec}.</strong> Standalone Maintenance Commands"
    when '1spp'  then "<strong>#{sec}.</strong> Standalone Diagnostics"
    when '1prom' then "<strong>#{sec}.</strong> Boot PROM Commands"
    when '1x'    then "<strong>#{sec}.</strong> X11 Commands"
    when '2'     then "<strong>#{sec}.</strong> System Calls"
    when '2prom' then "<strong>#{sec}.</strong> Boot PROM Calls"
    when '3'     then "<strong>#{sec}.</strong> Functions and Libraries"
    when '3c'    then "<strong>#{sec}.</strong> C Library"
    when '3f'    then "<strong>#{sec}.</strong> FORTRAN Library"
    when '3g'    then "<strong>#{sec}.</strong> General Purpose Library"
    when '3m'    then "<strong>#{sec}.</strong> Math Library"
    when '3n'    then "<strong>#{sec}.</strong> Network Support Library"
    when '3r'    then "<strong>#{sec}.</strong> RPC Library"
    when '3s'    then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3spp'  then "<strong>#{sec}.</strong> Standalone Library"
    when '3t'    then "<strong>#{sec}.</strong> Threads Library"
    when '3w'    then "<strong>#{sec}.</strong> International Library"
    when '3x'    then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '3y'    then "<strong>#{sec}.</strong> Yellow Pages Library"
    when '3x11'  then "<strong>#{sec}.</strong> X11 Library"
    when '3xt'   then "<strong>#{sec}.</strong> X Toolkit"
    when '4'     then "<strong>#{sec}.</strong> File Formats"
    when '4spp'  then "<strong>#{sec}.</strong> Standalone Device Drivers"
    when '5'     then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '5spp'  then "<strong>#{sec}.</strong> Standalone File Formats"
    when '6'     then "<strong>#{sec}.</strong> Games and Demos"
    when '7'     then "<strong>#{sec}.</strong> Special Files"
    when '7f'    then "<strong>#{sec}.</strong> Network Protocol Families"
    when '7n'    then "<strong>#{sec}.</strong> Network Interfaces"
    when '7p'    then "<strong>#{sec}.</strong> Network Protocols"
    when '8'     then "<strong>#{sec}.</strong> Maintenance Procedures"
    when '8c'    then "<strong>#{sec}.</strong> Network Services"
    else "Section #{sec}"
    end
  end

end
