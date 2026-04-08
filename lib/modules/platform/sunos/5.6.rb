# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/11/23.
# Copyright 2023 Typewritten Software. All rights reserved.
#
#
# Solaris 2.6 Platform Overrides
#
# TODO
#   ld.so.1(1) section becoming man1.1/ld.so.html somehow
#

module SunOS
  module V5_6
    class Source < Source
      def initialize(file, **kwargs, &block)
        case File.basename file
        when 'xil.macs' then raise ManualIsBlacklisted, 'is XIL manual macro package'
        end
        super(file, **kwargs, &block)
      end
    end

    class Troff < Troff

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
        mount_font 4, 'B'
        mount_font 5, 'R'
        mount_font 6, 'B'
      end

      def SB(*args)
        parse "\\&\\fB\\s-1\\&#{args[0..5].join(' ')}\\s0\\fR"
      end

      def TH(*args)
        ds "]H #{args[0]}\\^(\\^#{args[1]}\\^)"
        ds "]D #{MANUAL_SECTION_NAMES[args[1].downcase]}" if args[1]
        ds "]L Last change: #{args[2]}"
        ds "]W #{args[3]}" if args[3] and !args[3].strip.empty?
        ds "]D #{args[4]}" if args[4] and !args[4].strip.empty?

        heading = @named_strings['D'].empty? ? '\\*(]H' : '\\*(]H\\0\\0\\(em\\0\\0\\*(]D'
        # ]W moved to footer for 5.6, but I already had it there.
        @named_strings[:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @named_strings[']L'].empty?

        super(*args, heading: heading)
      end

      def TZ(*args)
        ds "Tz #{MANUAL_TITLES[args[0]]}"
        parse "\\fI\\*(Tz\\f1#{args[1]}"
      end

      def HC(*args)
        ds "Hc #{HARDCOPY_TITLES[args[0]]}"
        parse "\\fI\\*(Hc\\f1#{args[1]}"
      end

    end
    HARDCOPY_TITLES = {
            # Hard Copy Docs Only
      'HC_DRIVERINSTALL' => "Driver Developer Kit Installation Guide",
      'HC_OPENNEWSDDR' => "Driver Developer Kit Open Issues and Late-Breaking News",
      'HC_ENCRYPTINST' => "Encryption Kit Installation Guide",
      'HC_SPARCHW' => "SPARC Hardware Platform Guide",
      'HC_OPENNEWSUSER' => "Solaris 2.5 Open Issues and Late-Breaking News",
      'HC_x86DUG' => "Solaris 2.5 x86 Driver Update Guide",
      'HC_x86HW' => "Hardware Compatibility List for Solaris 2.6 (Intel Platform Edition)",
      'HC_ROADMAP' => "Solaris Roadmap",
      'HC_MEDIAPREPGU' => "Source Installation and Media Preparation Guide",
      'HC_SRCENCRYPT' => "Source Encryption Supplement",
      'HC_HWCONFIG' => "x86 Device Configuration Guide",
            # STANDARDS Conformance Books. Hard copy only
      'HC_POSIX1DOC' => "POSIX.1 CONFORMANCE DOCUMENT",
      'HC_POSIX2DOC' => "POSIX.2 CONFORMANCE DOCUMENT",
      'HC_XOPCDEDOC' => "X/OPEN COMMON DESKTOP ENVIRONMENT CONFORMANCE DOCUMENT",
      'HC_XOPUNIXDOC' => "X/OPEN UNIX CONFORMANCE DOCUMENT",
      'HC_XOPXPG3DOC' => "X/OPEN XPG3 CONFORMANCE DOCUMENT",
      'HC_RSMARNOTES' => "Product Notes: Sun RSM Array 2000 Software"
    }

    MANUAL_NAMES = {
      'ADMINSUPP' => "Administration Supplement for Solaris Platforms",
      'ADSUPRTADMIN' => "Solstice AdminSuite 2.1 Print Administration Guide",
      'ADVOSUG' => "Solaris Advanced User's Guide",
      'BINARY' => "Binary Compatibility Guide",
      'CDEPO' => "Common Desktop Environment: Programmer's Overview",
      'CDEPG' => "Solaris Common Desktop Environment: Programmer's Guide",
      'CDEPORTGU' => "Solaris Common Desktop Environment: Motif Transition Guide",
      'DDADD' => "Peripherals Administration",
      'DOCORDER' => "Doc Order Card",
      'DRIVER' => "Writing Device Drivers",
      'ENCRYPTINST' => "Encryption Kit Installation Guide",
      'FCODE' => "Writing FCode 2.x Programs",
      'FCODE_3.x' => "Writing FCode 3.x Programs",
      'FEDNAMESERV' => "Federated Naming Service Programming Guide",
      'HWCONFIG' => "Device Configuration Guide for Solaris 2.6 (Intel Platform Edition)",
      'I18N' => "Solaris Internationalization Guide For Developers",
      'INTRODRIVER' => "Driver Developer Kit Introduction",
      'LLM' => "Linker and Libraries Guide",
      'MAILADMIN' => "Mail Administration Guide",
      'MEDIAPREPGU' => "Source Installation and Media Preparation Guide",
      'MTP' => "Multithreaded Programming Guide",
      'NAMESERVINSTALL' => "Naming Services 1.2 Kit Installation Guide",
      'NETCOM' => "TCP/IP and Data Communications Administration Guide",
      'NETNAME' => "Solaris Naming Administration Guide",
      'NETP' => "Network Interfaces Programmer's Guide",
      'NETSHARE' => "NFS Administration Guide",
      'NETTRANS' => "NIS+ Transition Guide",
      'NISQSTART' => "Solaris Naming Setup and Configuration Guide",
      'QSTART' => "Solaris Common Desktop Environment: QuickStart",
      'OBQUICKREF_2.x' => "OpenBoot 2.x Quick Reference Card",
      'OBQUICKREF_3.x' => "OpenBoot 3.x Quick Reference Card",
      'OLITREF' => "OLIT Reference Manual",
      'OLITSTART' => "OLIT QuickStart Programmer's Guide",
      'ONCDG' => "ONC+ Developer's Guide",
      'ONLINEOPEN' => "Solaris 2.6 SUNWrdm",
      'OPENBOOTCMDREF' => "OpenBoot 2.x Command Reference Manual",
      'OPENBOOTCMDREF_3.x' => "OpenBoot 3.x Command Reference Manual",
      'OWDDG' => "X Server Device Developer's Guide",
      'OWPG' => "Solaris X Window System Developer's Guide",
      'OWREFMAN' => "OpenWindows Desktop Reference Manual",
      'PACKINSTALL' => "Application Packaging Developer's Guide",
      'PROGUTILS' => "Programming Utilities Guide",
      'REFMAN' => "SunOS Reference Manual",
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
      'SHIELD' => "SunSHIELD Basic Security Module Guide",
      'SOLBCKUPNOTES' => "Solstice Backup Installation and Product Notes",
      'SOLNETINSTALL' => "SolarNet PC Protocol Services 1.1: Installation Notes",
      'SOURCE' => "Source Compatibility Guide",
      'SPARC' => "SPARC Assembly Language Reference Manual",
      'SPARCINSTALL' => "Solaris Advanced Installation Guide",
      'SPARCINSTDESK' => "Installation Instructions for Solaris 2.6 (SPARC Platform Edition)",
      'SPARCINSTNOTES' => "Solaris 2.6 (SPARC Platform Edition) Release Notes",
      'SPSVRROADMAP' => "Solaris 2.6 Server Intranet Extension Roadmap",
      'SRCENCRYPT' => "Source Encryption Supplement",
      'SS' => "System Interface Guide",
      'SSUG' => "Solaris User's Guide",
      'STREAMS' => "STREAMS Programming Guide",
      'SYSADMIN1' => "System Administration Guide",
      'TRANSITION' => "Solaris 1.x to 2.x Transition Guide",
      'TRANSPORTPG' => "Transport Interfaces Programming Guide",
      'TROUBLESHOOT' => "Solaris Common Messages and Troubleshooting Guide",
      'TTREF' => "ToolTalk Reference Guide",
      'TTUG' => "ToolTalk User's Guide",
      'XGLDDKCB' => "Getting Started Writing XGL Device Handlers",
      'XWINREFMAN' => "Solaris X Window System Reference Manual",
      'x86' => "x86 Assembly Language Reference Manual",
      'x86DBINSTALL' => "Solaris x86 Installation Scripts for Database Server Systems",
      'x86HW' => "Hardware Compatibility List for Solaris 2.6 (Intel Platform Edition)",
      'x86INSTDESK' => "Installation Instructions for Solaris 2.6 (Intel Platform Edition)",
      'x86INSTNOTES' => "Solaris 2.6 (Intel Platform Edition) Release Notes",
      'x86SVRROADMAP' => "Solaris 2.6 Server Roadmap (Intel Platform Edition)",
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
            # KCMS
      'KCMSAPPDG' => "KCMS Application Developer's Guide",
      'KCMSCMMDG' => "KCMS CMM Developer's Guide",
      'KCMSCMMREF' => "KCMS CMM Reference Manual",
      'KCMSCALIBR' => "KCMS Calibrator Tool Loadable Interface Guide",
      'KCMSTESTUG' => "KCMS Test Suite User's Guide",
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
            # New for S2.6
      'CDEADMIN' => "Solaris Common Desktop Environment: Advanced User's and System Administrator's Guide",
      'CDEAPPLUG' => "Common Desktop Environment: Application Builder User's Guide",
      'CDEGLOSS' => "Common Desktop Environment: Product Glossary",
      'CDEHELP' => "Common Desktop Environment: Help System Author's and Programmer's Guide",
      'CDEINTRO' => "Introduction to Solaris Common Desktop Environment",
      'CDEL10NPG' => "Common Desktop Environment: Internationalization Programmer's Guide",
      'CDESTYLE' => "Common Desktop Environment: Style Guide and Certification Checklist",
      'CDETRANS' => "Solaris Common Desktop Environment: User's Transition Guide",
      'CDETTMSG' => "Common Desktop Environment: ToolTalk Messaging Overview",
      'CDEUG' => "Solaris Common Desktop Environment: User's Guide",
      'DTKSHUG' => "Common Desktop Environment: Desktop KornShell User's Guide",
      'FONTADMINUG' => "Font Administrator User's Guide",
      'SMAGTUG' => "Solstice SmartAgent 1.0 User Guide",
      'X500DIRMGNT' => "Solstice X.500 Directory Management",
      'SPARCINFOLIB' => "Information Library for Solaris 2.6 (SPARC Platform Edition)",
      'x86INFOLIB' => "Information Library for Solaris 2.6 (Intel Platform Edition)",
      'x86SVRLIGHT' => "Solaris 2.6 x86 Workgroup Server Roapmap",
      'ABOUTDOC' => "About Solaris 2.6 Documentation",
      'POWERGUIDE' => "Using Power Management",
      'SEAUG' => "Solstice Enterprise Agents 1.0 User Guide",
      'SMAGTDEV' => "Solstice Enterprise Agents 1.0 Development Guide",
      'ITRNETEXTNOTES' => "Solaris 2.6 Server Intranet Extension Installation and Release Notes",
      'AAPDEVREFMAN' => "Asian Application Developer's  Guide",
            # Enterprise 10000 Reference pages
      'ENTSSPUG' => "Ultra Enterprise 10000 SSP 3.0 User's Guide",
      'UE10000REFMAN1M' => "man Pages(1M): Ultra Enterprise 10000 SSP Administration Commands",
      'UE10000REFMAN4' => "man Pages(4): Ultra Enterprise 10000 SSP File Formats",
      'NTPUG' => "Network Time Protocol User's Guide",
      'NTPREFMAN1M' => "man Pages(1M): Network Time Protocol Commands",
      'DYNRCFUG' => "Dynamic Reconfiguration User's Guide",
      'DRREFMAN1M' => "man Pages(1M): DR Administration Commands",
      'ALTPATHUG' => "Alternate Pathing 2.0 User's Guide",
      'APREFMAN1M' => "man Pages(1M): Alternate Pathing Administration Commands",
      'APREFMAN7' => "man Pages(7): Alternate Pathing Special Files",
      'MEDLIBUG' => "Media Librarian 1.2 User's Guide",
      'MEDLIBADMIN' => "Media Librarian 1.2 Administrator's Guide",
      'ETMUG' => "Enterprise Tape Manager 1.2 User's Guide",
      'ETMADMIN' => "Enterprise Tape Manager 1.2 Administrator's Guide",
      'ETMMLREFMAN1' => "man Pages(1): ETM/ML Commands",
      'ETMMLREFMAN1M' => "man Pages(1M): ETM/ML Administration Commands",
      'ETMMLREFMAN4' => "man Pages(4): ETM/ML File Formats",
      'ETMMLREFMAN7' => "man Pages(7): ETM/ML Special Files",
      'SMCCSWREFMAN' => "Solaris Reference Manual for SMCC-Specific Software",
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
    }.freeze

    HARDCOPY_TITLES.default_proc = proc { |_h, k| "UNKNOWN TITLE ABBREVIATION: #{k}" }
    MANUAL_NAMES.default_proc = proc { |_h, k| "UNKNOWN TITLE ABBREVIATION: #{k}" }

    HARDCOPY_TITLES.freeze
    MANUAL_NAMES.freeze
  end
end
