# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Ultrix Platform Overrides
#

require_relative 'modules/ultrix/troff'
require_relative 'modules/ultrix_2.0.0'
require_relative 'modules/ultrix_3.1.0'
require_relative 'modules/ultrix_4.2.0'

module Ultrix

  def self.name_for_section(sec)
    case sec.downcase
    when '1'     then "<strong>#{sec}.</strong> Commands"
    when '1c'    then "<strong>#{sec}.</strong> Communication Commands"
    when '1g'    then "<strong>#{sec}.</strong> Graphics Commands"
    when '1int'  then "<strong>#{sec}.</strong> Internationalization Commands"
    when '1m'    then "<strong>#{sec}.</strong> Maintenance Commands"
    when '1mh'   then "<strong>#{sec}.</strong> RAND Message Handler Commands"
    when '1ncs'  then "<strong>#{sec}.</strong> Network Computing System Commands"
    when '1p'    then "<strong>#{sec}.</strong> Software Project Management System (SPMS) Commands"
    when '1sh5'  then "<strong>#{sec}.</strong> SVR2 Shell Commands"
    when '1x'    then "<strong>#{sec}.</strong> X11 Commands"
    when '1yp'   then "<strong>#{sec}.</strong> Yellow Pages (NIS) Commands"
    when '2'     then "<strong>#{sec}.</strong> System Calls"
    when '2nfs'  then "<strong>#{sec}.</strong> NFS Calls"
    when '2yp'   then "<strong>#{sec}.</strong> Yellow Pages (NIS) Calls"
    when '3'     then "<strong>#{sec}.</strong> Library Functions"
    when '3cur'  then "<strong>#{sec}.</strong> X/Open Curses Library"
    when '3dwt'  then "<strong>#{sec}.</strong> XUI Toolkit"
    when '3int'  then "<strong>#{sec}.</strong> International Suboutines"
    when '3krb'  then "<strong>#{sec}.</strong> Kerberos Library"
    when '3f'    then "<strong>#{sec}.</strong> FORTRAN Library"
    when '3m'    then "<strong>#{sec}.</strong> Math Library"
    when '3n'    then "<strong>#{sec}.</strong> Network Support Libraries"
    when '3ncs'  then "<strong>#{sec}.</strong> Network Computing System Library"
    when '3p'    then "<strong>#{sec}.</strong> Software Project Management System (SPMS) Routines"
    when '3s'    then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3thr'  then "<strong>#{sec}.</strong> pthreads Library"
    when '3x'    then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '3x11'  then "<strong>#{sec}.</strong> X11 Libraries"
    when '3xt'   then "<strong>#{sec}.</strong> X Toolkit"
    when '3xti'  then "<strong>#{sec}.</strong> X/Open Transport Interface"
    when '3yp'   then "<strong>#{sec}.</strong> Yellow Pages (NIS) Library"
    when '4'     then "<strong>#{sec}.</strong> Special Files"
    when '4f'    then "<strong>#{sec}.</strong> Network Protocol Families"
    when '4n'    then "<strong>#{sec}.</strong> Networking Facilities"
    when '4p'    then "<strong>#{sec}.</strong> Network Protocols"
    when '5'     then "<strong>#{sec}.</strong> File Formats"
    when '5x'    then "<strong>#{sec}.</strong> Motif File Formats"
    when '5cdfs' then "<strong>#{sec}.</strong> ISO 9660 Filesystem"
    when '5int'  then "<strong>#{sec}.</strong> International File Formats"
    when '5krb'  then "<strong>#{sec}.</strong> Kerberos File Formats"
    when '5mh'   then "<strong>#{sec}.</strong> RAND Message Handler File Formats"
    when '5nfs'  then "<strong>#{sec}.</strong> NFS File Formats"
    when '5n'    then "<strong>#{sec}.</strong> Networking File Formats"
    when '5yp'   then "<strong>#{sec}.</strong> Yellow Pages (NIS) File Formats"
    when '6'     then "<strong>#{sec}.</strong> Games and Demos"
    when '7'     then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '8'     then "<strong>#{sec}.</strong> Maintenance Procedures"
    when '8c'    then "<strong>#{sec}.</strong> Network Services"
    when '8cdfs' then "<strong>#{sec}.</strong> ISO 9660 Commands"
    when '8krb'  then "<strong>#{sec}.</strong> Kerberos Commands"
    when '8mh'   then "<strong>#{sec}.</strong> RAND Mail Handler Maintenance Commands"
    when '8n'    then "<strong>#{sec}.</strong> Network Services"
    when '8ncs'  then "<strong>#{sec}.</strong> Network Computing System Services"
    when '8nfs'  then "<strong>#{sec}.</strong> NFS Services"
    when '8ufs'  then "<strong>#{sec}.</strong> UFS Maintenance Commands"
    when '8v'    then "<strong>#{sec}.</strong> Maintenance Procedures"
    when '8x'    then "<strong>#{sec}.</strong> DECwindows Maintenance Tools"
    when '8yp'   then "<strong>#{sec}.</strong> Yellow Pages (NIS) Maintenance Commands"
    else "Section #{sec}"
    end

  end
end

# all the same tmac.an
# 4.0 still has NO NOTE in .NT, a couple of indent changes for nroff, and slightly
#     different page numbering in the footer, but we don't care. otherwise identical.
Ultrix::V4_0_0_mips = Ultrix::V4_2_0
Ultrix::V4_0_0_VAX  = Ultrix::V4_2_0
Ultrix::V4_1_0_mips = Ultrix::V4_2_0
Ultrix::V4_1_0_VAX  = Ultrix::V4_2_0
Ultrix::V4_2_0_mips = Ultrix::V4_2_0
Ultrix::V4_2_0_VAX  = Ultrix::V4_2_0
Ultrix::V4_4_0_mips = Ultrix::V4_2_0
Ultrix::V4_4_0_VAX  = Ultrix::V4_2_0
Ultrix::V4_5_1_mips = Ultrix::V4_2_0
Ultrix::V4_5_1_VAX  = Ultrix::V4_2_0
