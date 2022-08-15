# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 05/10/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# Solaris 2.5.1 Platform Overrides
#
# TODO special table macros (REVIEW what did I mean by this, tables look fine actually)
# TODO special .TH for intro
# TODO maybe an override for .SS, since it wants to use font escapes to emulate multiple levels of subhead - adb(1), ex(1), etc.
# TODO sccs(1) double quote appears in line 289, but not in postscript - argparsing wtf
# TODO many problems in ar(4)
# TODO allocb(9f), dupb(9f), linkb(9f) has box drawing - with raw postscript inclusion??
# TODO
#   maybe link commands list in column one of Intro(*), § "LIST OF ..."
#   LIST OF COMMANDS also occurs in other pages which themselves contain proper SEE ALSOs, so... ?
#   consider blacklisting List(*)
#   fnattr(1) :: [174] replace \t with ' '
#   if(1) :: [876,879] extra <br> in output after having messed with .TP
# √ sccs-get(1) :: tbl \^ row spans
# √ ld(1) :: [768] \hex - but we are currently bug compatible with psroff
# √ pcmapkeys(1) :: wants to overstrike é and è but I think we can reasonably rewrite these not to overstrike
# √ pvs(1) :: [112,113] '.if .n' / '.if .t'
# √ shell_builtins(1) :: the likely case for possibly implementing tbl change space between columns.
# √ spline(1) :: looks like it was preprocessed by eqn. psroff handles it, we don't very well. adequately, as of 20220718
#   ffbconfig(1m) :: [304] psroff doesn't care about this non-numeric argument to .TP, which seems odd. rewrite with \w.
#                          actually it does, the psroff output is not correct either. dunno where it gets \fB from
#   mount_cachefs(1m) :: [240] what made psroff break after the previous line without .nf?
#                              this error is probably a fat hint: <standard input>:240: warning [p 1, 0.0i]: cannot adjust line
#                              but, what does it MEAN. I'm not sure I'll be able to emulate it, whatever it is.
#   netstat(1m) :: [297] looks like the same problem as mount_cachefs(1m)
#   nslookup(1m) :: same problem as ffbconfig (non-numeric arg to .TP)
#   syncloop(1m) :: assorted cosmetic vertical spacing bugs (in tbl/after tbl? - looks like the in-tbl '.sp 4p's all happened at once, immediately post-tbl)
#   vmstat(1m) :: [105] expects to set _all_ cells in row \s-1 without explicit cell format.
#   sysconf(3c) :: [125] same as vmstat(1m)
#   sched_get_priority_max(3r) :: [26] .ta +8n +8n + 35n" -- figure out what is supposed to happen with this bad input. fix .ta so it doesn't nil.sub! (expressions.rb:102)
#   form_field_just(3x) :: [56] .ta 20n + 5n" -- same
#   a.out(4) :: [55,59,61] needs rewrite to give &nbsp outside \u...\d in order to avoid the cell collapsing (\u gives line-height:0 for correct results in non-table text)
#   ar(4) :: [289] too many tabs after format change
#   terminfo(4) :: tables have "B" echoed into header rows?
#

module SunOS_5_5_1

  def self.extended(k)
    k.define_singleton_method(:req_LP, k.method(:req_PP)) if k.methods.include?(:req_PP)
    case k.instance_variable_get '@input_filename'
    when 'ld.1'
      k.instance_variable_get('@source').lines[767].sub!(/\\h/, 'h')
    end
  end

  def init_fp
    super
    #@state[:fpmap]['BI'] = 4
    #@state[:fpmap]['CW'] = 5
    #@state[:fpmap]['H'] = :helv
    @state[:fonts][4] = 'BI'
    @state[:fonts][5] = 'CW'
    #@state[:fonts][:helv] = :sans
  end

  def init_sunos551
    @state[:sections] = {
      '1'  => 'User Commands',
      '1b' => 'SunOS/BSD Compatibility Package Commands',
      '1c' => 'Communication Commands',
      '1f' => 'FMLI Commands',
      '1g' => 'Graphics and CAD Commands',
      '1m' => 'Maintenance Commands',
      '1s' => 'SunOS Specific Commands',
      '2'  => 'System Calls',
      '3'  => 'C Library Functions',
      '3b' => 'SunOS/BSD Compatibility Library Functions',
      '3c' => 'C Library Functions',
      '3e' => 'C Library Functions',
      '3f' => 'Fortran Library Routines',
      '3g' => 'C Library Functions',
      '3i' => 'Wide Character Functions',
      '3k' => 'Kernel VM Library Functions',
      '3l' => 'Lightweight Processes Library',
      '3m' => 'Mathematical Library',
      '3n' => 'Network Functions',
      '3r' => 'Realtime Library',
      '3s' => 'Standard I/O Functions',
      '3t' => 'Thread Library',
      '3w' => 'C Library Functions',
      '3x' => 'Miscellaneous Library Functions',
      '4'  => 'File Formats',
      '4b' => 'SunOS/BSD Compatibility Package File Formats',
      '5'  => 'Headers, Tables, and Macros',
      '6'  => 'Games and Demos',
      '7'  => 'Device and Network Interfaces',
      '7b' => 'SunOS/BSD Compatibility Special Files',
      '7d' => 'Devices',
      '7fs' => 'File Systems',
      '7i' => 'Ioctl Requests',
      '7m' => 'STREAMS Modules',
      '7p' => 'Protocols',
      '8'  => 'Maintenance Procedures',
      '8c' => 'Maintenance Procedures',
      '8s' => 'Maintenance Procedures',
      '9'  => 'Device Driver Interfaces',
      '9e' => 'Driver Entry Points',
      '9f' => 'Kernel Functions for Drivers',
      '9s' => 'Data Structures for Drivers',
      'l'  => 'Local Commands'
    }
  end

  def init_ds
    super
    @state[:named_string].merge!({
      ']W' => 'SunOS 5.5.1',
      '||' => '/usr/share/lib/tmac'
    })
  end

  def req_TH(*args)
    heading = "#{args[0]}\\^(\\^#{args[1]}\\^)"
    req_ds(']D', @state[:sections][args[1].downcase]) if args[1]

    unescape("\\*(]W", output: @state[:footer])
    if args[2]
      req_ds ']L', "Last change: #{args[2]}"
      unescape '\\0\\0\\(em\\0\\0\\*(]L', output: @state[:footer]
    end

    req_ds(']W', args[3]) if args[3]
    req_ds(']D', args[4]) if args[4]
    heading << '\\0\\0\\(em\\0\\0\\*(]D' if @state[:named_string][']D'] and !@state[:named_string][']D'].empty?
    super(heading: heading)
  end

  def req_TZ(*args)
    req_ds('Tz', case args[0]
                 when 'ABADMIN' then "Software and AnswerBook Packages Administration Guide"
                 when 'ABINSTALL' then "Software and AnswerBook Installation Guide"
                 when 'ADMININDEX' then "Index to System and Network Administration Documentation"
                 when 'ADMINREF' then "Administration Application Reference Manual"
                 when 'ADMINSUPP' then "Administration Supplement for Solaris Platforms"
                 when 'ADSUPRTADMIN' then "Solstice AdminSuite 2.1 Print Administration Guide"
                 when 'ADVOSUG' then "Solaris Advanced User's Guide"
                 when 'ASPA' then "Security, Performance, and Accounting Administration"
                 when 'BINARY' then "Binary Compatibility Guide"
                 when 'CAT' then "Common Administration Tasks"
                 when 'CDEPORTGU' then "Solaris Common Desktop Environment: Motif Transition Guide"
                 when 'DDADD' then "Peripherals Administration"
                 when 'DESKSETQREF' then "DeskSet Quick Reference"
                 when 'DIRXLIBUG' then "Direct Xlib User's Guide"
                 when 'DOCORDER' then "Doc Order Card"
                 when 'DRIVER' then "Writing Device Drivers"
                 when 'ENCRYPTINST' then "Encryption Kit Installation Guide"
                 when 'FCODE' then "Writing FCode 2.x Programs"
                 when 'FCODE_3.x' then "Writing FCode 3.x Programs"
                 when 'FEDNAMESERV' then "Federated Naming Service Guide"
                 when 'HWCONFIG' then "x86 Device Configuration Guide"
                 when 'I18N' then "Developer's Guide to Internationalization"
                 when 'INTRODEV' then "Solaris 2.5 Software Developer Kit Introduction"
                 when 'INTRODRIVER' then "Driver Developer Kit Introduction"
                 when 'INTROUSER' then "Solaris 2.5 Introduction"
                 when 'LLM' then "Linker and Libraries Guide"
                 when 'MAILADMIN' then "Mail Administration Guide"
                 when 'MASTERDEV' then "Software Developer Kit Master Developer Series Guide"
                 when 'MEDIAPREPGU' then "Source Installation and Media Preparation Guide"
                 when 'MOTIFTRANS' then "OPENLOOK to Motif GUI Transition Guide"
                 when 'MTP' then "Multithreaded Programming Guide"
                 when 'NAMESERVINSTALL' then "Naming Services 1.2 Kit Installation Guide"
                 when 'NETCOM' then "TCP/IP and Data Communications Administration Guide"
                 when 'NETNAME' then "NIS+ and FNS Administration Guide"
                 when 'NETP' then "Network Interfaces Programmer's Guide"
                 when 'NETSHARE' then "NFS Administration Guide"
                 when 'NETTRANS' then "NIS+ Transition Guide"
                 when 'NISQSTART' then "NIS+ and DNS Setup and Configuration Guide"
                 when 'OBQUICKREF_2.x' then "OpenBoot 2.x Quick Reference Card"
                 when 'OBQUICKREF_3.x' then "OpenBoot 3.x Quick Reference Card"
                 when 'OLITREF' then "OLIT Reference Manual"
                 when 'OLITSTART' then "OLIT QuickStart Programmer's Guide"
                 when 'ONCDG' then "ONC+ Developer's Guide"
                 when 'ONLINEOPEN' then "2.5.1 Online Open Issues"
                 when 'OPENBOOTCMDREF' then "OpenBoot 2.x Command Reference Manual"
                 when 'OPENBOOTCMDREF_3.x' then "OpenBoot 3.x Command Reference Manual"
                 when 'OWDDG' then "X Server Device Developer's Guide"
                 when 'OWPG' then "Solaris X Window System Developer's Guide"
                 when 'OWREFMAN' then "OpenWindows Desktop Reference Manual"
                 when 'PACKINSTALL' then "Application Packaging Developer's Guide"
                 when 'PPCASSY' then "Solaris PowerPC Edition: Assembly Language Reference Manual"
                 when 'PPCDDKNOTES' then "Solaris 2.5 PowerPC Edition: Driver Developer Kit Release Note"
                 when 'PPCDEVINSTALL' then "Solaris 2.5.1 Software Developer Kit Installation Guide"
                 when 'PPCDRIVERINSTALL' then "Solaris 2.5.1:  Driver Developer Kit Installation Guide"
                 when 'PPCHW' then "Solaris 2.5.1 PowerPC Edition: Hardware Compatibility List"
                 when 'PPCINSTALL' then "Solaris PowerPC Edition: Installing Solaris Software"
                 when 'PPCINSTDESK' then "Solaris PowerPC Edition: Installing Solaris Software on the Desktop"
                 when 'PPCINSTNOTES' then "Solaris 2.5.1 PowerPC Edition: Installation Notes"
                 when 'PPCINTRODRIVER' then "Solaris 2.5.1:  Driver Developer Kit Introduction"
                 when 'PPCNOTES' then "Solaris 2.5.1: Release Notes"
                 when 'PPCPACKLIST' then "Solaris 2.5.1 PowerPC Edition: Desktop Roadmap"
                 when 'PPCSDKNOTES' then "Solaris 2.5.1: Software Developer Kit Release Notes"
                 when 'PPCSVRROADMAP' then "Solaris 2.5.1 PowerPC Edition: Workgroup Server Roadmap"
                 when 'PROGUTILS' then "Programming Utilities Guide"
                 when 'REFMAN' then "Sun OS Reference Manual"
                 when 'REFMAN1' then "man Pages(1): User Commands"
                 when 'REFMAN1M' then "man Pages(1M): System Administration Commands"
                 when 'REFMAN2' then "man Pages(2): System Calls"
                 when 'REFMAN3' then "man Pages(3): Library Routines"
                 when 'REFMAN4' then "man Pages(4): File Formats"
                 when 'REFMAN5' then "man Pages(5): Headers, Tables and Macros"
                 when 'REFMAN6' then "man Pages(6): Demos"
                 when 'REFMAN7' then "man Pages(7): Device and Network Interfaces"
                 when 'REFMAN9' then "man Pages(9): Device Driver Interfaces"
                 when 'REFMAN9E' then "man Pages(9E): Driver Entry Points"
                 when 'REFMAN9F' then "man Pages(9F): Kernel Functions for Drivers"
                 when 'REFMAN9S' then "man Pages(9S): Data Structures for Drivers"
                 when 'RSAG' then "File System Administration"
                 when 'SHIELD' then "SunSHIELD Basic Security Module Guide"
                 when 'SOLBCKUPNOTES' then "Solstice Backup Installation and Product Notes"
                 when 'SOLNETINSTALL' then "SolarNet PC Protocol Services 1.1: Installation Notes"
                 when 'SOURCE' then "Source Compatibility Guide"
                 when 'SPARC' then "SPARC Assembly Language Reference Manual"
                 when 'SPARCINSTALL' then "SPARC: Installing Solaris Software"
                 when 'SPARCINSTDESK' then "SPARC: Installing Solaris Software on the Desktop"
                 when 'SPARCINSTNOTES' then "Solaris 2.5.1 SPARC: Installation Notes"
                 when 'SPDTROADMAP' then "Solaris 2.5.1 SPARC: Desktop Roadmap"
                 when 'SPSVRROADMAP' then "Solaris 2.5.1 SPARC: Server Roadmap"
                 when 'SRCENCRYPT' then "Source Encryption Supplement"
                 when 'SS' then "System Interface Guide"
                 when 'SSDIG' then "Desktop Integration Guide"
                 when 'SSUG' then "Solaris User's Guide"
                 when 'STANDARDS' then "Standards Conformance Guide"
                 when 'STREAMS' then "STREAMS Programming Guide"
                 when 'SUNDIAG' then "SunDiag User's Guide"
                 when 'SUUPAM' then "User Accounts, Printers, and Mail Administration"
                 when 'SVCONVERT' then "XView Developer's Notes"
                 when 'SVRRELNOTES' then "Solaris 2.5.1 Server Release Notes"
                 when 'SYSADMIN1' then "System Administration Guide, Volume I"
                 when 'SYSADMIN2' then "System Administration Guide, Volume II"
                 when 'TELEOVERVIEW' then "XTL Architecture Guide"
                 when 'TRANSITION' then "Solaris 1.x to 2.x Transition Guide"
                 when 'TRANSPORTPG' then "Transport Interfaces Programming Guide"
                 when 'TROUBLESHOOT' then "Solaris Common Messages and Troubleshooting Guide"
                 when 'TTREF' then "ToolTalk Reference Guide"
                 when 'TTUG' then "ToolTalk User's Guide"
                 when 'UNDOCMSG' then "Undocumented Messages"
                 when 'XGLDDKCB' then "Getting Started Writing XGL Device Handlers"
                 when 'XTELADMIN' then "XTL Administrator's Guide"
                 when 'XTELPG' then "XTL Application Programmer's Guide"
                 when 'XTELPROVIDER' then "XTL Provider Programmer's Guide"
                 when 'XWINREFMAN' then "Solaris X Window System Reference Manual"
                 when 'x86' then "x86 Assembly Language Reference Manual"
                 when 'x86DBINSTALL' then "Solaris x86 Installation Scripts for Database Server Systems"
                 when 'x86DTROADMAP' then "Solaris 2.5.1 x86: Desktop Roadmap"
                 when 'x86HW' then "Solaris 2.5.1 x86 Hardware Compatibility List"
                 when 'x86INSTALL' then "x86: Installing Solaris Software"
                 when 'x86INSTDESK' then "x86: Installing Solaris Software on the Desktop"
                 when 'x86INSTNOTES' then "Solaris 2.5.1 x86: Installation Notes"
                 when 'x86SVRROADMAP' then "Solaris 2.5.1 x86: Server Roadmap"
                 when 'x86WGSVRMAP' then "Solaris 2.5.1 x86: Workgroup Server Roadmap"
        # SPARCstorage Array
                 when 'VOLMGRREFMAN' then "Manpages For The Volume Manager"
                 when 'ARRAYCONFG' then "SPARCstorage Array Configuration Guide"
                 when 'ARRAYUG' then "SPARCstorage Array User's Guide"
        # SPARCworks
                 when 'BROWSESC' then "Browsing Source Code"
                 when 'DEBUGAPROG' then "Debugging a Program"
                 when 'TOOLSET' then "Managing the Toolset"
                 when 'MAKETOOL' then "Building Programs with MakeTool"
                 when 'MERGE' then "Merging Source Files"
                 when 'PERFTUNAPP' then "Performance Tuning an Application"
                 when 'SPARCWTR' then "SPARCworks/ProWorks Tutorial"
        # Languages - C
                 when 'CTRANSITION' then "C 3.0.1 Transition Guide for SPARC Systems"
                 when 'CUG' then "C 3.0.1 User's Guide"
        # Languages - C++
                 when 'CLANGREF' then "C++ 4.0.1 Language System Product Reference Manual"
                 when 'CPPLIBREF' then "C++ 4.0.1 Library Reference Manual"
                 when 'CPPPUG' then "C++ 4.0.1 User's Guide"
        # Languages - Fortran
                 when 'FORTRANREF' then "FORTRAN 3.0.1 Reference Manual"
                 when 'FORTRANUG' then "FORTRAN 3.0.1 Users Guide"
        # Languages - Pascal
                 when 'PASCALREF' then "SPARCompiler Pascal 3.0.3 Reference Manual"
                 when 'PASCALUG' then "SPARCompiler Pascal 3.0.3 User Guide"
        # Languages - Common to all
                 when 'NUMCOMPGD' then "Numerical Computation Guide"
                 when 'PROGTOOLS' then "Profiling Tools"
                 when 'SWSC2' then "Installing SunPro Software on Solaris"
        # DiagExec
                 when 'BASICSDIAG' then "Basic System Diagnostics"
                 when 'GRAPHDIAG' then "Graphics Diagnostics"
                 when 'NETDIAG' then "Networking Diagnostics"
                 when 'PERIPHDIAG' then "Peripheral Diagnostics"
                 when 'SDIAGEXECPG' then "SunDiagnostic Executive Programmer's Guide"
                 when 'SDIAGEXECUG' then "Using the SunDiagnostic Executive"
                 when 'SDIAGEXECINST' then "SunDiagnostics AnswerBook Install"
                 when 'MPDQREF' then "MPDiag Quick Reference Guide"
                 when 'MPDUG' then "MPDiag User's Guide"
        # NeWSprint
                 when 'NPUSING' then "Using NeWSprint Printers"
                 when 'SPUSER' then "Using SunPics AnswerBook"
                 when 'NPINSTALL' then "Installing NeWSprint"
                 when 'NPADMIN' then "NeWSprint Printer Administrator's Guide"
                 when 'PRELIMN' then "PreLimn Reference Guide"
                 when 'NPREFERENCE' then "NeWSprint Reference"
                 when 'NPDEVGUIDE' then "NeWSprint Developer's Guide"
                 when 'NPRELEASE' then "NeWSprint Release Notes"
                 when 'SPINSTALL' then "SPARCprinter Installation and User's Guide"
                 when 'NP20INSTALL' then "NeWSprinter 20 Installation and User's Guide"
                 when 'SBUSINSTALL' then "SBus Printer Card Installation Guide"
        # DevGuide
                 when 'XVIEWCODEGEN' then "OpenWindows Developer's Guide: XView Code Generator Programmer's Guide"
                 when 'OLITCODEGEN' then "OpenWindows Developer's Guide: OLIT Code Generator Programmer's Guide"
                 when 'DEVGUIDEUG' then "OpenWindows Developer's Guide: User's Guide"
                 when 'MOTIFUTIL' then "OpenWindows Developer's Guide: Motif Conversion Utilities Guide"
        # KCMS
                 when 'KCMSAPPDG' then "KCMS Application Developer's Guide"
                 when 'KCMSCMMDG' then "KCMS CMM Developer's Guide"
                 when 'KCMSCMMREF' then "KCMS CMM Reference Manual"
                 when 'KCMSCALIBR' then "KCMS Calibrator Tool Loadable Interface Guide"
        # PEX
                 when 'PEXSPEC' then "Solaris PEX Implementation Specification"
                 when 'PEXLIBREFMAN' then "Solaris PEXlib Reference Manual"
                 when 'CGEPEXPORTG' then "CGE PEX 5.1 Portability Guide"
        # XGL
                 when 'XGLACCEL' then "XGL Accelerator Guide for Reference Frame Buffers"
                 when 'XGLARCH' then "XGL Architecture Guide"
                 when 'XGLDDKCOOKBOOK' then "Getting Started Writing XGL Device Handlers"
                 when 'XGLPORTGU' then "XGL Device Pipeline Porting Guide"
                 when 'XGLPG' then "XGL Programmer's Guide"
                 when 'XGLREFMAN' then "XGL Reference Manual"
                 when 'XGLTESTUG' then "XGL Test Suite User's Guide"
        # XIL
                 when 'XILPG' then "XIL Programmer's Guide"
                 when 'XILREFMAN' then "XIL Reference Manual"
                 when 'XILSYSPG' then "XIL Device Porting and Extensibility Guide"
                 when 'XILTESTUG' then "XIL Test Suite User's Guide"
        # non-Sun titles
                 when 'KR' then "The C Programming Language"
                 else "UNKNOWN TITLE ABBREVIATION: #{args[0]}"
                 end
    )
    unescape("\\fI\\*(Tz\\f1#{args[1]}")
  end

  def req_HC(*args)
    req_ds('Hc', case args[0]
        # Hard Copy Docs Only
                 when 'HC_DRIVERINSTALL' then "Driver Developer Kit Installation Guide"
                 when 'HC_OPENNEWSDDR' then "Driver Developer Kit Open Issues and Late-Breaking News"
                 when 'HC_ENCRYPTINST' then "Encryption Kit Installation Guide"
                 when 'HC_SPARCHW' then "SPARC Hardware Platform Guide"
                 when 'HC_DEVINSTALL' then "Software Developer Kit Installation Guide"
                 when 'HC_OPENNEWSDEV' then "Software Developer Kit Open Issues and Late-Breaking News"
                 when 'HC_OPENNEWSUSER' then "Solaris 2.5 Open Issues and Late-Breaking News"
                 when 'HC_x86DUG' then "Solaris 2.5 x86 Driver Update Guide"
                 when 'HC_x86HW' then "Solaris 2.5 x86 Hardware Compatibility List"
                 when 'HC_DESKSETQREF' then "Solaris QuickStart Guide"
                 when 'HC_ROADMAP' then "Solaris Roadmap"
                 when 'HC_MEDIAPREPGU' then "Source Installation and Media Preparation Guide"
                 when 'HC_SRCENCRYPT' then "Source Encryption Supplement"
                 when 'HC_HWCONFIG' then "x86 Device Configuration Guide"
                 else "UNKNOWN TITLE ABBREVIATION: #{args[0]}"
                 end
    )
    unescape("\\fI\\*(Hc\\f1#{args[1]}")
  end

  # no .TX in 5.5.1 macros
  #def req_TX(*args)
  #  # .TX t p	no	-	Resolve the title abbreviation t; join to punctuation mark (or text) p.
  #  warn "can't yet .TX #{args.inspect}"
  #end
end

=begin
Checked against .ps
§1
Intro awk csh dump
NIS+ nis+ (√ extra chars in numeric expression \s0)
alias (√ no .DG)
as (√ rejected string conditions)
audioconvert (√ pointless esc)
basename (√ horizontal motion)
col eject gencat (√ tbl)
diff3 (√ pathological use of negative \v is ignorable)
find (√ pointless esc)
=end
