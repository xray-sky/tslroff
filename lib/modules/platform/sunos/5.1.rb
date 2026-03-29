# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/11/23.
# Copyright 2023 Typewritten Software. All rights reserved.
#
#
# Solaris 2.1 Platform Overrides
#
#

class SunOS::V5_1
  class Troff < SunOS::Troff

    MANUAL_NAMES = {
      'APDEVGUIDE' => "Solaris 2.1 Application Developer's Guide",
      'APDEVTRANS' => "Solaris 2.1 Transition Guide",
      'ASPA' => "SunOS 5.1 Administering Security, Performance, and Accounting",
      'BINARY' => "Binary Compatibility Package Guide \\- Solaris 2.1",
      'CUIETI' => "SunOS 5.1 Character User Interface: Extended Terminal Interface",
      'CUIFMLI' => "SunOS 5.1 Character User Interface: Form and Menu Language Interpreter",
      'DDADD' => "SunOS 5.1 Adding and Maintaining Devices and Drivers",
      'DOCS' => "SunOS 5.1 Formatting Documents",
      'DRIVER' => "SunOS 5.1 Writing Device Drivers",
      'GS' => "Solaris 2.1 Getting Started",
      'HANDBOOK' => "Solaris 2.x Handbook for SMCC Peripherals",
      'HOWTO' => "SunOS 5.1 How-To Book: Basic System Administration Tasks",
      'I18N' => "Solaris 2.1 Developer's Guide to Internationalization",
      'INSTALL' => "Solaris 2.1 System Configuration and Installation Guide",
      'LLM' => "SunOS 5.1 Linker and Libraries Manual",
      'NETCOM' => "SunOS 5.1 Administering TCP/IP and UUCP",
      'NETNAME' => "SunOS 5.1 Administering NIS+ and DNS",
      'NETP' => "SunOS 5.1 Network Interfaces Programmer's Guide",
      'NETSHARE' => "SunOS 5.1 Administering NFS and RFS",
      'OSUG' => "SunOS 5.1 User's Guide",
      'OWDESKSET' => "OpenWindows Version 3.1 DeskSet Reference Guide",
      'OWDIG' => "OpenWindows Version 3.1 Desktop Integration Guide",
      'OWPG' => "OpenWindows Version 3.1 Programmer's Guide",
      'OWREFMAN' => "OpenWindows Version 3.1 Reference Manual",
      'OWUG' => "OpenWindows Version 3.1 User's Guide",
      'PACKINSTALL' => "SunOS 5.1 Application Packaging and Installation Guide",
      'PROGUTILS' => "SunOS 5.1 Programming Utilities ",
      'REALTIME' => "SunOS 5.1 Realtime Programmer's and Administrator's Guide",
      'REFMAN1' => "SunOS 5.1 Reference Manual",
      'REFMAN1M' => "SunOS 5.1 Reference Manual",
      'REFMAN2' => "SunOS 5.1 Reference Manual",
      'REFMAN3' => "SunOS 5.1 Reference Manual",
      'REFMAN3M' => "SunOS 5.1 Reference Manual",
      'REFMAN4' => "SunOS 5.1 Reference Manual",
      'REFMAN5' => "SunOS 5.1 Reference Manual",
      'REFMAN6' => "SunOS 5.1 Reference Manual",
      'REFMAN7' => "SunOS 5.1 Reference Manual",
      'REFMAN8' => "SunOS 5.1 Reference Manual",
      'REFMAN9E' => "SunOS 5.1 Reference Manual",
      'REFMAN9F' => "SunOS 5.1 Reference Manual",
      'REFMAN9S' => "SunOS 5.1 Reference Manual",
      'RELEASE' => "Solaris 2.1 Release ManuaL",
      'ROADMAP' => "Solaris 2.1 Roadmap to Documentation",
      'RSAG' => "SunOS 5.1 Routine System Administration Guide",
      'SMAG' => "Solaris 2.1 Software Manager Administrator's Guide",
      'SOURCE' => "SunOS/BSD Source Compatibility Package Guide \\- SunOS 5.1",
      'SPARC' => "SunOS 5.1 SPARC Assembly Language Reference Manual",
      'SS' => "SunOS 5.1 System Services",
      'STANDARDS' => "Solaris 2.1 Standards Conformance Guide",
      'STREAMS' => "SunOS 5.1 STREAMS Programmer's Guide",
      'SUNDIAG' => "Sundiag 4.1 User's Guide",
      'SUNDIAGADD' => "Sundiag 4.1 User's Guide - Addendum for SMCC Hardware",
      'SUUPAM' => "SunOS 5.1 Setting Up User Accounts, Printers and Mail",
      'SYSADTRANS' => "Solaris 2.1 Transition Guide",
      'TEXT' => "SunOS 5.1 Editing Text Files",
      'TROFF' => "SunOS 5.1 Using nroff and troff",
      'TTPG' => "ToolTalk 1.0.2 Programmer's Guide",
      'TTSAG' => "ToolTalk 1.0.2 Setup and Administration Guide",
      'USERTRANS' => "Solaris 2.1 Transition Guide",
            # SPARCstorage Array
      'VOLMGRREFMAN' => "Manpages For The Volume Manager",
      'ARRAYCONFG' => "SPARCstorage Array Configuration Guide",
      'ARRAYUG' => "SPARCstorage Array User's Guide",
            # SPARCworks
      'BROWSESC' => "Browsing Source Code",
      'DEBUGAPROG' => "Debugging a Program",
      'TOOLSET' => "Managing SPARCworks Tools",
      'MAKETOOL' => "Building Programs with MakeTool",
      'MERGE' => "Merging Source Files",
      'PERFTUNAPP' => "Performance-Tuning an Application",
      'SPARCWTR' => "Introduction to SPARCworks",
            # Languages - C
      'C2PG' => "SPARCompiler C 2.0.1 Programmers Guide",
      'CLIBREF' => "SPARCompiler C 2.0.1 Libraries Reference Manual",
      'CTRANGUIDE' => "SPARCompiler C 2.0.1 Transition Guide",
            # Languages - C++
      'CPPLIBMAN' => "SPARCompiler C++ 3.0.1 Language System Library Manual",
      'CPPREF' => "SPARCompiler C++ 3.0.1 Language System Product Reference Manual",
      'CPPPG' => "SPARCompiler C++ 3.0.1 Programmers Guide",
      'CPPRN' => "SPARCompiler C++ 3.0.1 Language System Release Notes",
      'CPPREADINGS' => "SPARCompiler C++ 3.0.1 Language System Selected Readings",
            # Languages - Fortran
      'FORTRANREF' => "SPARCompiler FORTRAN 2.0.1 Reference Manual",
      'FORTRANUG' => "SPARCompiler FORTRAN 2.0.1 Users Guide",
            # Languages - Pascal
      'PASCALREF' => "SPARCompiler Pascal 3.0.1 Reference Manual",
      'PASCALUG' => "SPARCompiler Pascal 3.0.1 User Guide",
            # Languages - Common to all
      'NUMCOMPGD' => "Numerical Computation Guide",
      'PROGTOOLS' => "Programming Tools",
      'SWSC1' => "Installing SPARCworks and SPARCompilers Software for Solaris 1.x",
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
      'TNTCODEGEN' => "OpenWindows Developer's Guide: Programmer's Guide to The NewS Toolkit 3.0.1 Code Generator",
      'XVIEWCODEGEN' => "OpenWindows Developer's Guide: Programmer's Guide to the XView 3.0.1 Toolkit Code Generator",
      'OLITCODEGEN' => "OpenWindows Developer's Guide: Programmer's Guide to the OLIT 3.0.1 Code Generator",
      'DEVGUIDEUG' => "OpenWindows Developer's Guide 3.0.1 User's Guide",
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
      '3r'  => 'RPC Services Library',
      '3s'  => 'Standard I/O Functions',
      '3w'  => 'C Library Functions',
      '3x'  => 'Miscellaneous Library Functions',
      '3xc' => 'X/Open Curses Library Functions',
      '3xn' => 'X/Open Networking Services Library Functions',
      '4'   => 'File Formats',
      '4b'  => 'SunOS/BSD Compatibility Package File Formats',
      '5'   => 'Environments, Tables, and TROFF Macros',
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

    def SB(*args)
      parse "\\&\\fB\\s-1\\&#{args[0..5].join(' ')}\\s0\\fR"
    end

    def TH(*args)
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

    def TZ(*args)
      ds "Tz #{MANUAL_NAMES[args[0]]}"
      parse "\\fI\\*(Tz\\f1#{args[1]}"
    end

  end
end
