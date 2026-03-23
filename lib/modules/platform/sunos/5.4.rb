# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/11/23.
# Copyright 2023 Typewritten Software. All rights reserved.
#
#
# Solaris 2.4 Platform Overrides
#
#

class SunOS::V5_4
  class Troff < ::SunOS::Troff

    HARDCOPY_TITLES = {
          # Hard Copy Docs Only
      'HC_DRIVERINSTALL' => "Driver Developer Kit Installation Guide",
      'HC_OPENNEWSDDR' => "Driver Developer Kit Open Issues and Late-Breaking News",
      'HC_ENCRYPTINST' => "Encryption Kit Installation Guide",
      'HC_SPARCHW' => "SPARC Hardware Platform Guide",
      'HC_DEVINSTALL' => "Software Developer Kit Installation Guide",
      'HC_OPENNEWSDEV' => "Software Developer Kit Open Issues and Late-Breaking News",
      'HC_OPENNEWSUSER' => "Solaris 2.4 Open Issues and Late-Breaking News",
      'HC_x86DUG' => "Solaris 2.4 x86 Driver Update Guide",
      'HC_x86HW' => "Solaris 2.4 x86 Hardware Compatibility List",
      'HC_DESKSETQREF' => "Solaris QuickStart Guide",
      'HC_ROADMAP' => "Solaris Roadmap",
      'HC_MEDIAPREPGU' => "Solaris Source Installation and Media Preparation Guide",
      'HC_SRCENCRYPT' => "Source Encryption Supplement",
      'HC_HWCONFIG' => "x86 Device Configuration Guide"
    }

    MANUAL_NAMES = {
      'ABADMIN' => "Software and AnswerBook Packages Administration Guide",
      'ADMINREF' => "Administration Application Reference Manual",
      'ADMINSUPP' => "Administration Supplement for Solaris Platforms",
      'ADVOSUG' => "Solaris Advanced User's Guide",
      'ASPA' => "Security, Performance, and Accounting Administration",
      'BINARY' => "Solaris Binary Compatibility Guide",
      'CAT' => "Common Administration Tasks",
      'DDADD' => "Peripherals Administration",
      'DIRXLIBUG' => "Direct Xlib User's Guide",
      'DRIVER' => "Writing Device Drivers",
      'FCODE' => "Writing FCode Programs",
      'I18N' => "Developer's Guide to Internationalization",
      'INTRODEV' => "Software Developer Kit Introduction",
      'INTRODRIVER' => "Driver Developer Kit Introduction",
      'INTROUSER' => "Solaris 2.4 Introduction",
      'LLM' => "Linker and Libraries Guide",
      'MOTIFTRANS' => "OPENLOOK to Motif GUI Transition Guide",
      'MTP' => "Multithreaded Programming",
      'NETCOM' => "TCP/IP Network Administration Guide",
      'NETNAME' => "Name Services Administration Guide",
      'NETP' => "Network Interfaces Programmer's Guide",
      'NETSHARE' => "NFS Administration Guide",
      'NETTRANS' => "NIS+ Transition Guide",
      'NISQSTART' => "Name Service Setup and Configuration Guide",
      'OLITREF' => "OLIT Reference Manual",
      'OLITSTART' => "OLIT QuickStart Programmer's Guide",
      'OPENBOOTCMDREF' => "OpenBoot Command Reference Manual",
      'OWDDG' => "OpenWindows Server Device Developer's Guide",
      'OWPG' => "OpenWindows Server Programmer's Guide",
      'OWREFMAN' => "OpenWindows Reference Manual",
      'PACKINSTALL' => "Application Packaging Developer's Guide",
      'PROGUTILS' => "Programming Utilities Guide",
      'REFMAN1' => "man Pages(1): User Commands",
      'REFMAN1M' => "man Pages(1M): System Administration Commands",
      'REFMAN2' => "man Pages(2): System Calls",
      'REFMAN3' => "man Pages(3): Library Routines",
      'REFMAN4' => "man Pages(4): File Formats",
      'REFMAN5' => "man Pages(5): Headers, Tables and Macros",
      'REFMAN6' => "man Pages(6): Demos",
      'REFMAN7' => "man Pages(7): Special Files",
      'REFMAN9' => "man Pages(9): DDI and DKI Overview",
      'REFMAN9E' => "man Pages(9E): DDI and DKI Driver Entry Points",
      'REFMAN9F' => "man Pages(9F): DDI and DKI Kernel Functions",
      'REFMAN9S' => "man Pages(9S): DDI and DKI Data Structures",
      'RSAG' => "File System Administration",
      'SHIELD' => "SunSHIELD Basic Security Module Guide",
      'SOURCE' => "Solaris Source Compatibility Guide",
      'SPARC' => "SPARC Assembly Language Reference Manual",
      'SPARCINSTALL' => "SPARC: Installing Solaris Software",
      'SS' => "System Services Guide",
      'SSDIG' => "Desktop Integration Guide",
      'SSUG' => "Solaris User's Guide",
      'STANDARDS' => "Standards Conformance Reference Manual",
      'STREAMS' => "STREAMS Programmer's Guide",
      'SUNDIAG' => "SunDiag User's Guide",
      'SUUPAM' => "User Accounts, Printers, and Mail Administration",
      'SVCONVERT' => "XView Developer's Notes",
      'TELEOVERVIEW' => "XTL Architecture Guide",
      'TRANSITION' => "Solaris 1.x to Solaris 2.x Transition Guide",
      'TTREF' => "ToolTalk Reference Manual",
      'TTUG' => "ToolTalk User's Guide",
      'XTELADMIN' => "XTL Administrator's Guide",
      'XTELPG' => "XTL Application Programmer's Guide",
      'XTELPROVIDER' => "XTL Provider Programmer's Guide",
      'x86' => "x86 Assembly Language Reference Manual",
      'x86INSTALL' => "x86: Installing Solaris Software",
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
      'SDIAGEXECINST' => "SunDiagnostics Answerbook Install",
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
          # XGL
      'XGLARCH' => "XGL Architecture Guide",
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
      '3k'  => 'Kernel VM Library Functions',
      '3l'  => 'Lightweight Processes Library',
      '3m'  => 'Mathematical Library',
      '3n'  => 'Network Functions',
      '3r'  => 'Realtime Library',
      '3s'  => 'Standard I/O Functions',
      '3t'  => 'Thread Library',
      '3w'  => 'C Library Functions',
      '3x'  => 'Miscellaneous Library Functions',
      '3xc' => 'X/Open Curses Library Functions',
      '3xn' => 'X/Open Networking Services Library Functions',
      '4'   => 'File Formats',
      '4b'  => 'SunOS/BSD Compatibility Package File Formats',
      '5'   => 'Headers, Environments, and Macros',
      '6'   => 'Games and Demos',
      '7'   => 'Special Files',
      '7b'  => 'SunOS/BSD Compatibility Special Files',
      '8'   => 'Maintenance Procedures',
      '8c'  => 'Maintenance Procedures',
      '8s'  => 'Maintenance Procedures',
      '9'   => 'DDI and DKI',
      '9e'  => 'DDI and DKI Driver Entry Points',
      '9f'  => 'DDI and DKI Kernel Functions',
      '9s'  => 'DDI and DKI Data Structures',
      'l'   => 'Local Commands'
    }

    HARDCOPY_TITLES.default_proc = proc { |_h, k| "UNKNOWN TITLE ABBREVIATION: #{k}" }
    MANUAL_NAMES.default_proc = proc { |_h, k| "UNKNOWN TITLE ABBREVIATION: #{k}" }

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
      # Palatino family for postscript output (PA, PI, PB)
      super
      @mounted_fonts[4] = 'B'
      @mounted_fonts[5] = 'R'
      @mounted_fonts[6] = 'B'
    end

    define_method 'SB' do |*args|
      parse "\\&\\fB\\s-1\\&#{args[0..5].join(' ')}\\s0\\fR"
    end

    define_method 'TH' do |*args|
      ds "]H #{args[0]}\\^(\\^#{args[1]}\\^)"
      ds "]D #{MANUAL_SECTION_NAMES[args[1].downcase]}" if args[1]
      ds "]L Last change: #{args[2]}"
      ds "]W #{args[3]}" if args[3] and !args[3].strip.empty?
      ds "]D #{args[4]}" if args[4] and !args[4].strip.empty?

      heading = '\\*(]H'
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
