# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/11/23.
# Copyright 2023 Typewritten Software. All rights reserved.
#
#
# Solaris 2.3 Platform Overrides
#
# TODO
# √ huge numbers of missing pages (e.g. most of section 1m) - what happened??
#    - looks like aspppls(1m) tries to .so itself??
#    - consider making .so resilient to this
#

class SunOS::V5_3
  class Troff < ::SunOS::Troff

    MANUAL_NAMES = {
      'ABADMIN' => "Solaris 2.3 AnswerBook  Administration Guide",
      'ADMINUG' => "SunOS 5.3 User's Guide to System Administration",
      'ADVOSUG' => "Solaris 2.3 Advanced User's Guide",
      'ASPA' => "Solaris 2.3 Administering Security, Performance, and Accounting",
      'BACKUP' => "Online: Backup 2.1 Administration Guide",
      'BINARY' => "Solaris 2.3 Binary Compatibility Guide",
      'DDADD' => "Solaris 2.3 Adding and Maintaining Peripherals",
      'DEVGUIDEUIBUILD' => "OpenWindows Developer's Guide 3.3: A User Interface Builder",
      'DIRXLIBUG' => "Direct Xlib 3.0 User's Guide",
      'DRIVER' => "SunOS 5.3 Writing Device Drivers",
      'I18N' => "Solaris 2.3 Developer's Guide to Internationalization",
      'INSTALL' => "Solaris 2.3 System Configuration and Installation Guide",
      'L10N' => "Solaris 2.3 Localization Guide",
      'LLM' => "SunOS 5.3 Linker and Libraries Manual",
      'MTP' => "SunOS 5.3 Guide to Multi-Thread Programming",
      'NETCOM' => "SunOS 5.3 Administering TCP/IP and PPP",
      'NETNAME' => "SunOS 5.3 Administering NIS+ and DNS",
      'NETP' => "SunOS 5.3 Network Interfaces Programmer's Guide",
      'NETSHARE' => "SunOS 5.3 Administering NFS",
      'NEWFEATURES' => "Solaris 2.3 New Features",
      'OLITREF' => "OLIT 3.2 Reference Manual",
      'OLITSTART' => "OLIT Getting Started Guide",
      'OWPG' => "OpenWindows 3.3 Programmer's Guide",
      'OWREFMAN' => "OpenWindows 3.3 Reference Manual",
      'PACKINSTALL' => "Solaris 2.3 Developer's Guide to Application Packaging",
      'PROGUTILS' => "SunOS 5.3 Programming Utilities",
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
      'RELEASE' => "Solaris 2.3 Release Manual",
      'ROADMAP' => "Solaris 2.3 Roadmap to Documentation",
      'RSAG' => "Solaris 2.3 Administering File Systems",
      'SHIELD' => "Solaris SHIELD Basic Security Module",
      'SMAG' => "Solaris 2.3 Software Manager User's Guide",
      'SOURCE' => "Solaris 2.3 Source Compatibility Manual",
      'SPARC' => "SunOS 5.3 SPARC Assembly Language Reference Manual",
      'SS' => "SunOS 5.3 System Services",
      'SSDIG' => "Solaris 2.3 Desktop Integration Guide",
      'SSUG' => "Solaris 2.3 User's Guide",
      'STANDARDS' => "Solaris 2.3 Standards Conformance Guide",
      'STREAMS' => "SunOS 5.3 STREAMS Programmer's Guide",
      'SUNDIAG' => "SunDiag 4.3 User's Guide",
      'SUUPAM' => "Solaris 2.3 Adding User Accounts, Printers, and Mail",
      'SVCONVERT' => "XView 3.2 Developer's Notes",
      'TRANSITION' => "Solaris 2.3 Transition Guide",
      'TTREF' => "ToolTalk 1.1.1 Reference Manual",
      'TTUG' => "ToolTalk 1.1.1 User's Guide",
      'x86' => "SunOS 5.3 x86 Assembly Language Reference Manual",
      'x86INSTALL' => "x86: Installing Solaris Software",
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
      'C2PG' => "SPARCompiler C 2.0.1 Programmer's Guide",
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

    MANUAL_NAMES.default_proc = proc { |_h, k| "UNKNOWN TITLE ABBREVIATION: #{k}" }

    def initialize(source)
      case source.file
      when 'aspppls.1m'
        raise ManualIsBlacklisted, 'pathological use of .so'
      end
      super(source)
    end

    def init_ds
      super
      @state[:named_string].merge!(
        {
          ']W' => "Sun Microsystems",
          '||' => '/usr/share/lib/tmac'
        }
      )
    end

    def init_fp
      # Palatino family for postscript output (PA, PI, PB)
      super
      @state[:fonts][4] = 'B'
      @state[:fonts][5] = 'R'
      @state[:fonts][6] = 'B'
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
      heading << '\\0\\0\\(em\\0\\0\\*(]D' unless @state[:named_string][']D'].empty?
      @state[:named_string][:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @state[:named_string][']L'].empty?

      super(heading: heading)
    end

    define_method 'TZ' do |*args|
      ds "Tz #{MANUAL_NAMES[args[0]]}"
      parse "\\fI\\*(Tz\\f1#{args[1]}"
    end

  end
end
