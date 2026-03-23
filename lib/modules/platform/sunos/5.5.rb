# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/10/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# Solaris 2.5 Platform Overrides
#
# 2.5 TODO
#
# 2.5.1 TODO
#
# TODO special table macros (REVIEW what did I mean by this, tables look fine actually)
# TODO special .TH for intro
# TODO maybe an override for .SS, since it wants to use font escapes to emulate multiple levels of subhead - adb(1), ex(1), etc.
# TODO sccs(1) double quote appears in line 289, but not in postscript - argparsing wtf
# TODO pic - allocb(9f), dupb(9f), linkb(9f) - postprocessed?!
# TODO
#   maybe link commands list in column one of Intro(*), § "LIST OF ..."
#   LIST OF COMMANDS also occurs in other pages which themselves contain proper SEE ALSOs, so... ?
#   consider blacklisting List(*)
#   consider using CMU Bright or Sans for sans
#   eqn(1) :: adjust bracket pile and extended radical offsets in case we do switch from Palatino to Computer Modern font
#   eqn(1) :: consider special CMU Math font for eqn? (there isn't one but look around maybe) - ∑ in particular looks bad
#   fnattr(1) :: [174] replace \t with ' '
# √ if(1) :: [876,879] extra <br> in output after having messed with .TP
# √ sccs-get(1) :: tbl \^ row spans
# √ ld(1) :: [768] \hex - but we are currently bug compatible with psroff
# √ pcmapkeys(1) :: wants to overstrike é and è but I think we can reasonably rewrite these not to overstrike
# √ pvs(1) :: [112,113] '.if .n' / '.if .t'
# √ shell_builtins(1) :: the likely case for possibly implementing tbl change space between columns.
# √ spline(1) :: looks like it was preprocessed by eqn. psroff handles it, we don't very well. adequately, as of 20220718
#   stty(1) :: some font size issue at Local Modes => iexten, after icanon - not returning to standard after \s-
#   tput(1) :: same (Environment)
#   ffbconfig(1m) :: [304] psroff doesn't care about this non-numeric argument to .TP, which seems odd. rewrite with \w.
#                          actually it does, the psroff output is not correct either. dunno where it gets \fB from
#   mount_cachefs(1m) :: [240] what made psroff break after the previous line without .nf?
#                              this error is probably a fat hint: <standard input>:240: warning [p 1, 0.0i]: cannot adjust line
#                              but, what does it MEAN. I'm not sure I'll be able to emulate it, whatever it is.
#   netstat(1m) :: [297] looks like the same problem as mount_cachefs(1m)
#   nslookup(1m) :: same problem as ffbconfig (non-numeric arg to .TP)
# √ syncloop(1m) :: assorted cosmetic vertical spacing bugs (in tbl/after tbl? - looks like the in-tbl '.sp 4p's all happened at once, immediately post-tbl)
#   vmstat(1m) :: [105] expects to set _all_ cells in row \s-1 without explicit cell format.
#   fork(2) :: bullets in Description section?
#   sysconf(3c) :: [125] same as vmstat(1m)
#   sched_get_priority_max(3r) :: [26] .ta +8n +8n + 35n" -- figure out what is supposed to happen with this bad input. fix .ta so it doesn't nil.sub! (expressions.rb:102)
#   form_field_just(3x) :: [56] .ta 20n + 5n" -- same
# √ a.out(4) :: [55,59,61] needs rewrite to give &nbsp outside \u...\d in order to avoid the cell collapsing (\u gives line-height:0 for correct results in non-table text)
# √ ar(4) :: [289] too many tabs after format change
# √ terminfo(4) :: tables have "B" echoed into header rows?
#   terminfo(4) :: \o, \z for box drawing chars in sec. 1-12 not appearing correctly/at all (same problem with many platforms terminfo(4))
#   terminfo(4) :: has inline eqn but all the enablement is commented out. probably will just leave this, since it's busted in troff too?
#   mansun(5) :: tbl vs. <table> column widths (see wrap in '.TH n s d f m')
#   mtio(7i) :: has postprocessed tbl (mostly output correctly, just needs horizontal rules)
#   mtio(7i) :: font size at MTSRSZ and MTGRSZ ? extra space after initial " on MTNBSF/MTFSF ? what happened here
#

class SunOS::V5_5
  class Troff < ::SunOS::Troff

    HARDCOPY_TITLES = {
          # Hard Copy Docs Only
      'HC_DRIVERINSTALL' => "Driver Developer Kit Installation Guide",
      'HC_OPENNEWSDDR' => "Driver Developer Kit Open Issues and Late-Breaking News",
      'HC_ENCRYPTINST' => "Encryption Kit Installation Guide",
      'HC_SPARCHW' => "SPARC Hardware Platform Guide",
      'HC_DEVINSTALL' => "Software Developer Kit Installation Guide",
      'HC_OPENNEWSDEV' => "Software Developer Kit Open Issues and Late-Breaking News",
      'HC_OPENNEWSUSER' => "Solaris 2.5 Open Issues and Late-Breaking News",
      'HC_x86DUG' => "Solaris 2.5 x86 Driver Update Guide",
      'HC_x86HW' => "Solaris 2.5 x86 Hardware Compatibility List",
      'HC_DESKSETQREF' => "Solaris QuickStart Guide",
      'HC_ROADMAP' => "Solaris Roadmap",
      'HC_MEDIAPREPGU' => "Source Installation and Media Preparation Guide",
      'HC_SRCENCRYPT' => "Source Encryption Supplement",
      'HC_HWCONFIG' => "x86 Device Configuration Guide"
    }

    MANUAL_NAMES = {
      'ABADMIN' => "Software and AnswerBook Packages Administration Guide",
      'ABINSTALL' => "Software and AnswerBook Installation Guide",
      'ADMININDEX' => "Index to System and Network Administration Documentation",
      'ADMINREF' => "Administration Application Reference Manual",
      'ADMINSUPP' => "Administration Supplement for Solaris Platforms",
      'ADSUPRTADMIN' => "Solstice AdminSuite 2.1 Print Administration Guide",
      'ADVOSUG' => "Solaris Advanced User's Guide",
      'ASPA' => "Security, Performance, and Accounting Administration",
      'BINARY' => "Binary Compatibility Guide",
      'CAT' => "Common Administration Tasks",
      'CDEPORTGU' => "Solaris Common Desktop Environment: Motif Transition Guide",
      'DDADD' => "Peripherals Administration",
      'DESKSETQREF' => "DeskSet Quick Reference",
      'DIRXLIBUG' => "Direct Xlib User's Guide",
      'DOCORDER' => "Doc Order Card",
      'DRIVER' => "Writing Device Drivers",
      'ENCRYPTINST' => "Encryption Kit Installation Guide",
      'FCODE' => "Writing FCode 2.x Programs",
      'FCODE_3.x' => "Writing FCode 3.x Programs",
      'FEDNAMESERV' => "Federated Naming Service Guide",
      'HWCONFIG' => "x86 Device Configuration Guide",
      'I18N' => "Developer's Guide to Internationalization",
      'INTRODEV' => "Solaris 2.5 Software Developer Kit Introduction",
      'INTRODRIVER' => "Driver Developer Kit Introduction",
      'INTROUSER' => "Solaris 2.5 Introduction",
      'LLM' => "Linker and Libraries Guide",
      'MAILADMIN' => "Mail Administration Guide",
      'MASTERDEV' => "Software Developer Kit Master Developer Series Guide",
      'MEDIAPREPGU' => "Source Installation and Media Preparation Guide",
      'MOTIFTRANS' => "OPENLOOK to Motif GUI Transition Guide",
      'MTP' => "Multithreaded Programming Guide",
      'NAMESERVINSTALL' => "Naming Services 1.2 Kit Installation Guide",
      'NETCOM' => "TCP/IP and Data Communications Administration Guide",
      'NETNAME' => "NIS+ and FNS Administration Guide",
      'NETP' => "Network Interfaces Programmer's Guide",
      'NETSHARE' => "NFS Administration Guide",
      'NETTRANS' => "NIS+ Transition Guide",
      'NISQSTART' => "NIS+ and DNS Setup and Configuration Guide",
      'OBQUICKREF_2.x' => "OpenBoot 2.x Quick Reference Card",
      'OBQUICKREF_3.x' => "OpenBoot 3.x Quick Reference Card",
      'OLITREF' => "OLIT Reference Manual",
      'OLITSTART' => "OLIT QuickStart Programmer's Guide",
      'ONCDG' => "ONC+ Developer's Guide",
      'ONLINEOPEN' => "2.5.1 Online Open Issues",
      'OPENBOOTCMDREF' => "OpenBoot 2.x Command Reference Manual",
      'OPENBOOTCMDREF_3.x' => "OpenBoot 3.x Command Reference Manual",
      'OWDDG' => "X Server Device Developer's Guide",
      'OWPG' => "Solaris X Window System Developer's Guide",
      'OWREFMAN' => "OpenWindows Desktop Reference Manual",
      'PACKINSTALL' => "Application Packaging Developer's Guide",
      'PPCASSY' => "Solaris PowerPC Edition: Assembly Language Reference Manual",
      'PPCDDKNOTES' => "Solaris 2.5 PowerPC Edition: Driver Developer Kit Release Note",
      'PPCDEVINSTALL' => "Solaris 2.5.1 Software Developer Kit Installation Guide",
      'PPCDRIVERINSTALL' => "Solaris 2.5.1:  Driver Developer Kit Installation Guide",
      'PPCHW' => "Solaris 2.5.1 PowerPC Edition: Hardware Compatibility List",
      'PPCINSTALL' => "Solaris PowerPC Edition: Installing Solaris Software",
      'PPCINSTDESK' => "Solaris PowerPC Edition: Installing Solaris Software on the Desktop",
      'PPCINSTNOTES' => "Solaris 2.5.1 PowerPC Edition: Installation Notes",
      'PPCINTRODRIVER' => "Solaris 2.5.1:  Driver Developer Kit Introduction",
      'PPCNOTES' => "Solaris 2.5.1: Release Notes",
      'PPCPACKLIST' => "Solaris 2.5.1 PowerPC Edition: Desktop Roadmap",
      'PPCSDKNOTES' => "Solaris 2.5.1: Software Developer Kit Release Notes",
      'PPCSVRROADMAP' => "Solaris 2.5.1 PowerPC Edition: Workgroup Server Roadmap",
      'PROGUTILS' => "Programming Utilities Guide",
      'REFMAN' => "Sun OS Reference Manual",
      'REFMAN1' => "man Pages(1): User Commands",
      'REFMAN1M' => "man Pages(1M): System Administration Commands",
      'REFMAN2' => "man Pages(2): System Calls",
      'REFMAN3' => "man Pages(3): Library Routines",
      'REFMAN4' => "man Pages(4): File Formats",
      'REFMAN5' => "man Pages(5): Headers, Tables and Macros",
      'REFMAN6' => "man Pages(6): Demos",
      'REFMAN7' => "man Pages(7): Device and Network Interfaces",
      'REFMAN9' => "man Pages(9): Device Driver Interfaces",
      'REFMAN9E' => "man Pages(9E): Driver Entry Points",
      'REFMAN9F' => "man Pages(9F): Kernel Functions for Drivers",
      'REFMAN9S' => "man Pages(9S): Data Structures for Drivers",
      'RSAG' => "File System Administration",
      'SHIELD' => "SunSHIELD Basic Security Module Guide",
      'SOLBCKUPNOTES' => "Solstice Backup Installation and Product Notes",
      'SOLNETINSTALL' => "SolarNet PC Protocol Services 1.1: Installation Notes",
      'SOURCE' => "Source Compatibility Guide",
      'SPARC' => "SPARC Assembly Language Reference Manual",
      'SPARCINSTALL' => "SPARC: Installing Solaris Software",
      'SPARCINSTDESK' => "SPARC: Installing Solaris Software on the Desktop",
      'SPARCINSTNOTES' => "Solaris 2.5.1 SPARC: Installation Notes",
      'SPDTROADMAP' => "Solaris 2.5.1 SPARC: Desktop Roadmap",
      'SPSVRROADMAP' => "Solaris 2.5.1 SPARC: Server Roadmap",
      'SRCENCRYPT' => "Source Encryption Supplement",
      'SS' => "System Interface Guide",
      'SSDIG' => "Desktop Integration Guide",
      'SSUG' => "Solaris User's Guide",
      'STANDARDS' => "Standards Conformance Guide",
      'STREAMS' => "STREAMS Programming Guide",
      'SUNDIAG' => "SunDiag User's Guide",
      'SUUPAM' => "User Accounts, Printers, and Mail Administration",
      'SVCONVERT' => "XView Developer's Notes",
      'SVRRELNOTES' => "Solaris 2.5.1 Server Release Notes",
      'SYSADMIN1' => "System Administration Guide, Volume I",
      'SYSADMIN2' => "System Administration Guide, Volume II",
      'TELEOVERVIEW' => "XTL Architecture Guide",
      'TRANSITION' => "Solaris 1.x to 2.x Transition Guide",
      'TRANSPORTPG' => "Transport Interfaces Programming Guide",
      'TROUBLESHOOT' => "Solaris Common Messages and Troubleshooting Guide",
      'TTREF' => "ToolTalk Reference Guide",
      'TTUG' => "ToolTalk User's Guide",
      'UNDOCMSG' => "Undocumented Messages",
      'XGLDDKCB' => "Getting Started Writing XGL Device Handlers",
      'XTELADMIN' => "XTL Administrator's Guide",
      'XTELPG' => "XTL Application Programmer's Guide",
      'XTELPROVIDER' => "XTL Provider Programmer's Guide",
      'XWINREFMAN' => "Solaris X Window System Reference Manual",
      'x86' => "x86 Assembly Language Reference Manual",
      'x86DBINSTALL' => "Solaris x86 Installation Scripts for Database Server Systems",
      'x86DTROADMAP' => "Solaris 2.5.1 x86: Desktop Roadmap",
      'x86HW' => "Solaris 2.5.1 x86 Hardware Compatibility List",
      'x86INSTALL' => "x86: Installing Solaris Software",
      'x86INSTDESK' => "x86: Installing Solaris Software on the Desktop",
      'x86INSTNOTES' => "Solaris 2.5.1 x86: Installation Notes",
      'x86SVRROADMAP' => "Solaris 2.5.1 x86: Server Roadmap",
      'x86WGSVRMAP' => "Solaris 2.5.1 x86: Workgroup Server Roadmap",
          # SPARCstorage Array
      'VOLMGRREFMAN' => "Manpages For The Volume Manager",
      'ARRAYCONFG' => "SPARCstorage Array Configuration Guide",
      'ARRAYUG' => "SPARCstorage Array User's Guide",
          # SPARCworks
      'BROWSESC' => "Browsing Source Code",
      'DEBUGAPROG' => "Debugging a Program",
      'TOOLSET' => "Managing the Toolset",
      'MAKETOOL' => "Building Programs with MakeTool",
      'MERGE' => "Merging Source Files",
      'PERFTUNAPP' => "Performance Tuning an Application",
      'SPARCWTR' => "SPARCworks/ProWorks Tutorial",
          # Languages - C
      'CTRANSITION' => "C 3.0.1 Transition Guide for SPARC Systems",
      'CUG' => "C 3.0.1 User's Guide",
          # Languages - C++
      'CLANGREF' => "C++ 4.0.1 Language System Product Reference Manual",
      'CPPLIBREF' => "C++ 4.0.1 Library Reference Manual",
      'CPPPUG' => "C++ 4.0.1 User's Guide",
          # Languages - Fortran
      'FORTRANREF' => "FORTRAN 3.0.1 Reference Manual",
      'FORTRANUG' => "FORTRAN 3.0.1 Users Guide",
          # Languages - Pascal
      'PASCALREF' => "SPARCompiler Pascal 3.0.3 Reference Manual",
      'PASCALUG' => "SPARCompiler Pascal 3.0.3 User Guide",
          # Languages - Common to all
      'NUMCOMPGD' => "Numerical Computation Guide",
      'PROGTOOLS' => "Profiling Tools",
      'SWSC2' => "Installing SunPro Software on Solaris",
          # DiagExec
      'BASICSDIAG' => "Basic System Diagnostics",
      'GRAPHDIAG' => "Graphics Diagnostics",
      'NETDIAG' => "Networking Diagnostics",
      'PERIPHDIAG' => "Peripheral Diagnostics",
      'SDIAGEXECPG' => "SunDiagnostic Executive Programmer's Guide",
      'SDIAGEXECUG' => "Using the SunDiagnostic Executive",
      'SDIAGEXECINST' => "SunDiagnostics AnswerBook Install",
      'MPDQREF' => "MPDiag Quick Reference Guide",
      'MPDUG' => "MPDiag User's Guide",
          # NeWSprint
      'NPUSING' => "Using NeWSprint Printers",
      'SPUSER' => "Using SunPics AnswerBook",
      'NPINSTALL' => "Installing NeWSprint",
      'NPADMIN' => "NeWSprint Printer Administrator's Guide",
      'PRELIMN' => "PreLimn Reference Guide",
      'NPREFERENCE' => "NeWSprint Reference",
      'NPDEVGUIDE' => "NeWSprint Developer's Guide",
      'NPRELEASE' => "NeWSprint Release Notes",
      'SPINSTALL' => "SPARCprinter Installation and User's Guide",
      'NP20INSTALL' => "NeWSprinter 20 Installation and User's Guide",
      'SBUSINSTALL' => "SBus Printer Card Installation Guide",
          # DevGuide
      'XVIEWCODEGEN' => "OpenWindows Developer's Guide: XView Code Generator Programmer's Guide",
      'OLITCODEGEN' => "OpenWindows Developer's Guide: OLIT Code Generator Programmer's Guide",
      'DEVGUIDEUG' => "OpenWindows Developer's Guide: User's Guide",
      'MOTIFUTIL' => "OpenWindows Developer's Guide: Motif Conversion Utilities Guide",
          # KCMS
      'KCMSAPPDG' => "KCMS Application Developer's Guide",
      'KCMSCMMDG' => "KCMS CMM Developer's Guide",
      'KCMSCMMREF' => "KCMS CMM Reference Manual",
      'KCMSCALIBR' => "KCMS Calibrator Tool Loadable Interface Guide",
          # PEX
      'PEXSPEC' => "Solaris PEX Implementation Specification",
      'PEXLIBREFMAN' => "Solaris PEXlib Reference Manual",
      'CGEPEXPORTG' => "CGE PEX 5.1 Portability Guide",
          # XGL
      'XGLACCEL' => "XGL Accelerator Guide for Reference Frame Buffers",
      'XGLARCH' => "XGL Architecture Guide",
      'XGLDDKCOOKBOOK' => "Getting Started Writing XGL Device Handlers",
      'XGLPORTGU' => "XGL Device Pipeline Porting Guide",
      'XGLPG' => "XGL Programmer's Guide",
      'XGLREFMAN' => "XGL Reference Manual",
      'XGLTESTUG' => "XGL Test Suite User's Guide",
          # XIL
      'XILPG' => "XIL Programmer's Guide",
      'XILREFMAN' => "XIL Reference Manual",
      'XILSYSPG' => "XIL Device Porting and Extensibility Guide",
      'XILTESTUG' => "XIL Test Suite User's Guide",
          # non-Sun titles
      'KR' => "The C Programming Language"
    }

    MANUAL_SECTION_NAMES = {
      '1'   => 'User Commands',
      '1b'  => 'SunOS/BSD Compatibility Package Commands',
      '1c'  => 'Communication Commands',
      '1f'  => 'FMLI Commands',
      '1g'  => 'Graphics and CAD Commands',
      '1m'  => 'Maintenance Commands',
      '1s'  => 'SunOS Specific Commands',
      '2'   => 'System Calls',
      '3'   => 'C Library Functions',
      '3b'  => 'SunOS/BSD Compatibility Library Functions',
      '3c'  => 'C Library Functions',
      '3e'  => 'C Library Functions',
      '3f'  => 'Fortran Library Routines',
      '3g'  => 'C Library Functions',
      '3i'  => 'Wide Character Functions',
      '3k'  => 'Kernel VM Library Functions',
      '3l'  => 'Lightweight Processes Library',
      '3m'  => 'Mathematical Library',
      '3n'  => 'Network Functions',
      '3r'  => 'Realtime Library',
      '3s'  => 'Standard I/O Functions',
      '3t'  => 'Thread Library',
      '3w'  => 'C Library Functions',
      '3x'  => 'Miscellaneous Library Functions',
      '4'   => 'File Formats',
      '4b'  => 'SunOS/BSD Compatibility Package File Formats',
      '5'   => 'Headers, Tables, and Macros',
      '6'   => 'Games and Demos',
      '7'   => 'Device and Network Interfaces',
      '7b'  => 'SunOS/BSD Compatibility Special Files',
      '7d'  => 'Devices',
      '7fs' => 'File Systems',
      '7i'  => 'Ioctl Requests',
      '7m'  => 'STREAMS Modules',
      '7p'  => 'Protocols',
      '8'   => 'Maintenance Procedures',
      '8c'  => 'Maintenance Procedures',
      '8s'  => 'Maintenance Procedures',
      '9'   => 'Device Driver Interfaces',
      '9e'  => 'Driver Entry Points',
      '9f'  => 'Kernel Functions for Drivers',
      '9s'  => 'Data Structures for Drivers',
      'l'   => 'Local Commands'
    }

    HARDCOPY_TITLES.default_proc = proc { |_h, k| "UNKNOWN TITLE ABBREVIATION: #{k}" }
    MANUAL_NAMES.default_proc = proc { |_h, k| "UNKNOWN TITLE ABBREVIATION: #{k}" }

    def source_init
      case @source.file
      when 'ld.1' then @source.patch_line(768, /\\h/, 'h')
      when 'a.out.4' # h4x: collapsed tbl cells due to line-height:0 from \u...\d
        @source.patch_lines([55, 59, 61], /(\\u.+?\\d)/, '\\ \1\\ ', global: true)
      when 'ar.4' # h4x: missing single quote in input; not sure how troff copes - perhaps \(ga matches ' ?? ugh... TODO
        @source.patch_line(42, /\\h\\\(ga/, "\\h'")
      end
      super
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          ']W' => "SunOS #{@version}",
          '||' => '/usr/share/lib/tmac'
        }
      )
    end

    def init_fp
      super
      @mounted_fonts[4] = 'BI' # REVIEW is this right? or is it H ...or S???
      @mounted_fonts[5] = 'CW'
    end

    define_method 'SB' do |*args|
      parse "\\&\\fB\\s-1\\&#{args[0..5].join(' ')}\\s0\\fR"
    end

    define_method 'TH' do |*args|
      ds "]D #{MANUAL_SECTION_NAMES[args[1].downcase]}" if args[1]
      ds "]L Last change: #{args[2]}"
      ds "]W #{args[3]}" if args[3] and !args[3].strip.empty?
      ds "]D #{args[4]}" if args[4] and !args[4].strip.empty?

      heading = "#{args[0]}\\^(\\^#{args[1]}\\^)"
      heading << '\\0\\0\\(em\\0\\0\\*(]D' unless @named_strings[']D'].empty?
      @named_strings[:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @named_strings[']L'].empty?

      super(*args, heading: heading)
    end

    define_method 'TZ' do |*args|
      ds "Tz #{MANUAL_NAMES[args[0]]}"
      parse "\\fI\\*(Tz\\f1#{args[1]}"
    end

    define_method 'HC' do |*args|
      ds "Hc #{HARDCOPY_TITLES[args[0]]}"
      parse "\\fI\\*(Hc\\f1#{args[1]}"
    end

  end
end
class SunOS::V5_5_1 < SunOS::V5_5 ; end
