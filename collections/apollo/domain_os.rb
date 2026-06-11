# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/04/21.
# Copyright 2021 Typewritten Software. All rights reserved.
#
#
# Apollo DomainOS Platform Overrides
#
# nroff seems to be formatted for screen (three part title appears only at top;
# no page length, even for pages which retain overstrikes)
#
# some troff mixed in
#
# "help" format is plain text, with directory structure, some in-line metadata,
#  and somewhat different rules around "SEE ALSO"
#

require_relative 'modules/domain_os/manual'

module Aegis

  def self.name_for_section(sec)
    case sec.downcase
    when '1'    then "<strong>#{sec}.</strong> Commands"
    when '1c'   then "<strong>#{sec}.</strong> Communications Commands"
    when '1g'   then "<strong>#{sec}.</strong> Graphics Commands"
    when '1m'   then "<strong>#{sec}.</strong> Maintenance Commands"
    when '1x'   then "<strong>#{sec}.</strong> Motif Commands"
    when '2'    then "<strong>#{sec}.</strong> System Calls"
    when '2j'   then "<strong>#{sec}.</strong> Job Control Calls"
    when '2v'   then "<strong>#{sec}.</strong> System V Compatibility Calls"
    when '3'    then "<strong>#{sec}.</strong> Subroutines"
    when '3c'   then "<strong>#{sec}.</strong> Communications Routines"
    when '3f'   then "<strong>#{sec}.</strong> FORTRAN Library"
    when '3j'   then "<strong>#{sec}.</strong> Job Control Facilities"
    when '3m'   then "<strong>#{sec}.</strong> Math Library"
    when '3n'   then "<strong>#{sec}.</strong> Networking Routines"
    when '3p'   then "<strong>#{sec}.</strong> POSIX Threads Library"
    when '3s'   then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3t'   then "<strong>#{sec}.</strong> Mach Threads Library"
    when '3x'   then "<strong>#{sec}.</strong> Miscellaneous Routines"
    when '3x11' then "<strong>#{sec}.</strong> X11 Library"
    when '3xt'  then "<strong>#{sec}.</strong> X Toolkit"
    when '4'    then "<strong>#{sec}.</strong> Special Files"
    when '4f'   then "<strong>#{sec}.</strong> Network Protocol Families"
    when '4n'   then "<strong>#{sec}.</strong> Networking Facilities"
    when '4p'   then "<strong>#{sec}.</strong> Network Protocols"
    when '4x'   then "<strong>#{sec}.</strong> Vue File Formats"
    when '5'    then "<strong>#{sec}.</strong> File Formats"
    when '6'    then "<strong>#{sec}.</strong> Games"
    when '6x'   then "<strong>#{sec}.</strong> X11 Games"
    when '7'    then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '8'    then "<strong>#{sec}.</strong> Maintenance Procedures"
    when '8c'   then "<strong>#{sec}.</strong> Network Services"
    when 'a'    then "Apollo System Calls and Routines"
    when /^hel/ then sec.upcase # Aegis HELP
    else "Section #{sec}"
    end
  end

end

# module aliases
DomainOS = Aegis
DomainIX = Aegis
AUX = DomainIX

require_relative 'modules/aegis_sr8.0'
require_relative 'modules/aegis_sr8.1'
require_relative 'modules/aegis_sr9.5'
require_relative 'modules/aegis_sr9.7.5'
require_relative 'modules/domain_os_sr10.3.5'
require_relative 'modules/domain_os_sr10.4'
require_relative 'modules/domain_os_sr10.4.1'

Aegis::SR7_B = Aegis
Aegis::SR9_0 = Aegis
Aegis::SR9_0_020 = Aegis
Aegis::SR9_2 = Aegis
Aegis::SR9_6 = Aegis
Aegis::SR9_7 = Aegis
Aegis::SR9_7_1 = Aegis
DomainIX::SR9_2_3 = DomainIX
DomainOS::SR10_0 = DomainOS
DomainOS::SR10_1 = DomainOS
DomainOS::SR10_1_PSK4 = DomainOS
DomainOS::SR10_2 = DomainOS
DomainOS::SR10_3 = DomainOS
