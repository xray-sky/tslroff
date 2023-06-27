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

module SunOS_5_6

  def self.extended(k)
    #case k.instance_variable_get '@input_filename'
    #when 'ld.1'
    #  k.instance_variable_get('@source').lines[767].sub!(/\\h/, 'h')
    #when 'a.out.4' # h4x: collapsed tbl cells due to line-height:0 from \u...\d
    #  k.instance_variable_get('@source').lines[54].sub!(/(\\u.+?\\d)/, '\\ \1\\ ')
    #  k.instance_variable_get('@source').lines[58].sub!(/(\\u.+?\\d)/, '\\ \1\\ ')
    #  k.instance_variable_get('@source').lines[60].gsub!(/(\\u.+?\\d)/, '\\ \1\\ ')
    #when 'ar.4' # h4x: missing single quote in input; not sure how troff copes - perhaps \(ga matches ' ?? ugh... TODO
    #  k.instance_variable_get('@source').lines[41].sub!(/\\h\\\(ga/, "\\h'")
    #end
  end

  def init_ds
    super
    @state[:named_string].merge!(
      {
        ']W' => "SunOS #{@version}",
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

  def init_sunos56
    @state[:sections] = {
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
    }
  end

  define_method 'SB' do |*args|
    parse "\\&\\fB\\s-1\\&#{args[0..5].join(' ')}\\s0\\fR"
  end

  define_method 'TH' do |*args|
    req_ds "]H #{args[0]}\\^(\\^#{args[1]}\\^)"
    req_ds "]D #{@state[:sections][args[1].downcase]}" if args[1]
    req_ds "]L Last change: #{args[2]}"
    req_ds "]W #{args[3]}" if args[3] and !args[3].strip.empty?
    req_ds "]D #{args[4]}" if args[4] and !args[4].strip.empty?

    heading = '\\*(]H'
    heading << '\\0\\0\\(em\\0\\0\\*(]D' unless @state[:named_string][']D'].empty?
    # ]W moved to footer for 5.6, but I already had it there.
    @state[:named_string][:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @state[:named_string][']L'].empty?

    super(heading: heading)
  end

  define_method 'TZ' do |*args|
    req_ds('Tz ' + case args[0]
                   when 'ADMINSUPP' then "Administration Supplement for Solaris Platforms"
                   when 'ADSUPRTADMIN' then "Solstice AdminSuite 2.1 Print Administration Guide"
                   when 'ADVOSUG' then "Solaris Advanced User's Guide"
                   when 'BINARY' then "Binary Compatibility Guide"
                   when 'CDEPO' then "Common Desktop Environment: Programmer's Overview"
                   when 'CDEPG' then "Solaris Common Desktop Environment: Programmer's Guide"
                   when 'CDEPORTGU' then "Solaris Common Desktop Environment: Motif Transition Guide"
                   when 'DDADD' then "Peripherals Administration"
                   when 'DOCORDER' then "Doc Order Card"
                   when 'DRIVER' then "Writing Device Drivers"
                   when 'ENCRYPTINST' then "Encryption Kit Installation Guide"
                   when 'FCODE' then "Writing FCode 2.x Programs"
                   when 'FCODE_3.x' then "Writing FCode 3.x Programs"
                   when 'FEDNAMESERV' then "Federated Naming Service Programming Guide"
                   when 'HWCONFIG' then "Device Configuration Guide for Solaris 2.6 (Intel Platform Edition)"
                   when 'I18N' then "Solaris Internationalization Guide For Developers"
                   when 'INTRODRIVER' then "Driver Developer Kit Introduction"
                   when 'LLM' then "Linker and Libraries Guide"
                   when 'MAILADMIN' then "Mail Administration Guide"
                   when 'MEDIAPREPGU' then "Source Installation and Media Preparation Guide"
                   when 'MTP' then "Multithreaded Programming Guide"
                   when 'NAMESERVINSTALL' then "Naming Services 1.2 Kit Installation Guide"
                   when 'NETCOM' then "TCP/IP and Data Communications Administration Guide"
                   when 'NETNAME' then "Solaris Naming Administration Guide"
                   when 'NETP' then "Network Interfaces Programmer's Guide"
                   when 'NETSHARE' then "NFS Administration Guide"
                   when 'NETTRANS' then "NIS+ Transition Guide"
                   when 'NISQSTART' then "Solaris Naming Setup and Configuration Guide"
                   when 'QSTART' then "Solaris Common Desktop Environment: QuickStart"
                   when 'OBQUICKREF_2.x' then "OpenBoot 2.x Quick Reference Card"
                   when 'OBQUICKREF_3.x' then "OpenBoot 3.x Quick Reference Card"
                   when 'OLITREF' then "OLIT Reference Manual"
                   when 'OLITSTART' then "OLIT QuickStart Programmer's Guide"
                   when 'ONCDG' then "ONC+ Developer's Guide"
                   when 'ONLINEOPEN' then "Solaris 2.6 SUNWrdm"
                   when 'OPENBOOTCMDREF' then "OpenBoot 2.x Command Reference Manual"
                   when 'OPENBOOTCMDREF_3.x' then "OpenBoot 3.x Command Reference Manual"
                   when 'OWDDG' then "X Server Device Developer's Guide"
                   when 'OWPG' then "Solaris X Window System Developer's Guide"
                   when 'OWREFMAN' then "OpenWindows Desktop Reference Manual"
                   when 'PACKINSTALL' then "Application Packaging Developer's Guide"
                   when 'PROGUTILS' then "Programming Utilities Guide"
                   when 'REFMAN' then "SunOS Reference Manual"
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
                   when 'SHIELD' then "SunSHIELD Basic Security Module Guide"
                   when 'SOLBCKUPNOTES' then "Solstice Backup Installation and Product Notes"
                   when 'SOLNETINSTALL' then "SolarNet PC Protocol Services 1.1: Installation Notes"
                   when 'SOURCE' then "Source Compatibility Guide"
                   when 'SPARC' then "SPARC Assembly Language Reference Manual"
                   when 'SPARCINSTALL' then "Solaris Advanced Installation Guide"
                   when 'SPARCINSTDESK' then "Installation Instructions for Solaris 2.6 (SPARC Platform Edition)"
                   when 'SPARCINSTNOTES' then "Solaris 2.6 (SPARC Platform Edition) Release Notes"
                   when 'SPSVRROADMAP' then "Solaris 2.6 Server Intranet Extension Roadmap"
                   when 'SRCENCRYPT' then "Source Encryption Supplement"
                   when 'SS' then "System Interface Guide"
                   when 'SSUG' then "Solaris User's Guide"
                   when 'STREAMS' then "STREAMS Programming Guide"
                   when 'SYSADMIN1' then "System Administration Guide"
                   when 'TRANSITION' then "Solaris 1.x to 2.x Transition Guide"
                   when 'TRANSPORTPG' then "Transport Interfaces Programming Guide"
                   when 'TROUBLESHOOT' then "Solaris Common Messages and Troubleshooting Guide"
                   when 'TTREF' then "ToolTalk Reference Guide"
                   when 'TTUG' then "ToolTalk User's Guide"
                   when 'XGLDDKCB' then "Getting Started Writing XGL Device Handlers"
                   when 'XWINREFMAN' then "Solaris X Window System Reference Manual"
                   when 'x86' then "x86 Assembly Language Reference Manual"
                   when 'x86DBINSTALL' then "Solaris x86 Installation Scripts for Database Server Systems"
                   when 'x86HW' then "Hardware Compatibility List for Solaris 2.6 (Intel Platform Edition)"
                   when 'x86INSTDESK' then "Installation Instructions for Solaris 2.6 (Intel Platform Edition)"
                   when 'x86INSTNOTES' then "Solaris 2.6 (Intel Platform Edition) Release Notes"
                   when 'x86SVRROADMAP' then "Solaris 2.6 Server Roadmap (Intel Platform Edition)"
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
          # KCMS
                   when 'KCMSAPPDG' then "KCMS Application Developer's Guide"
                   when 'KCMSCMMDG' then "KCMS CMM Developer's Guide"
                   when 'KCMSCMMREF' then "KCMS CMM Reference Manual"
                   when 'KCMSCALIBR' then "KCMS Calibrator Tool Loadable Interface Guide"
                   when 'KCMSTESTUG' then "KCMS Test Suite User's Guide"
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
          # New for S2.6
                   when 'CDEADMIN' then "Solaris Common Desktop Environment: Advanced User's and System Administrator's Guide"
                   when 'CDEAPPLUG' then "Common Desktop Environment: Application Builder User's Guide"
                   when 'CDEGLOSS' then "Common Desktop Environment: Product Glossary"
                   when 'CDEHELP' then "Common Desktop Environment: Help System Author's and Programmer's Guide"
                   when 'CDEINTRO' then "Introduction to Solaris Common Desktop Environment"
                   when 'CDEL10NPG' then "Common Desktop Environment: Internationalization Programmer's Guide"
                   when 'CDESTYLE' then "Common Desktop Environment: Style Guide and Certification Checklist"
                   when 'CDETRANS' then "Solaris Common Desktop Environment: User's Transition Guide"
                   when 'CDETTMSG' then "Common Desktop Environment: ToolTalk Messaging Overview"
                   when 'CDEUG' then "Solaris Common Desktop Environment: User's Guide"
                   when 'DTKSHUG' then "Common Desktop Environment: Desktop KornShell User's Guide"
                   when 'FONTADMINUG' then "Font Administrator User's Guide"
                   when 'SMAGTUG' then "Solstice SmartAgent 1.0 User Guide"
                   when 'X500DIRMGNT' then "Solstice X.500 Directory Management"
                   when 'SPARCINFOLIB' then "Information Library for Solaris 2.6 (SPARC Platform Edition)"
                   when 'x86INFOLIB' then "Information Library for Solaris 2.6 (Intel Platform Edition)"
                   when 'x86SVRLIGHT' then "Solaris 2.6 x86 Workgroup Server Roapmap"
                   when 'ABOUTDOC' then "About Solaris 2.6 Documentation"
                   when 'POWERGUIDE' then "Using Power Management"
                   when 'SEAUG' then "Solstice Enterprise Agents 1.0 User Guide"
                   when 'SMAGTDEV' then "Solstice Enterprise Agents 1.0 Development Guide"
                   when 'ITRNETEXTNOTES' then "Solaris 2.6 Server Intranet Extension Installation and Release Notes"
                   when 'AAPDEVREFMAN' then "Asian Application Developer's  Guide"
          # Enterprise 10000 Reference pages
                   when 'ENTSSPUG' then "Ultra Enterprise 10000 SSP 3.0 User's Guide"
                   when 'UE10000REFMAN1M' then "man Pages(1M): Ultra Enterprise 10000 SSP Administration Commands"
                   when 'UE10000REFMAN4' then "man Pages(4): Ultra Enterprise 10000 SSP File Formats"
                   when 'NTPUG' then "Network Time Protocol User's Guide"
                   when 'NTPREFMAN1M' then "man Pages(1M): Network Time Protocol Commands"
                   when 'DYNRCFUG' then "Dynamic Reconfiguration User's Guide"
                   when 'DRREFMAN1M' then "man Pages(1M): DR Administration Commands"
                   when 'ALTPATHUG' then "Alternate Pathing 2.0 User's Guide"
                   when 'APREFMAN1M' then "man Pages(1M): Alternate Pathing Administration Commands"
                   when 'APREFMAN7' then "man Pages(7): Alternate Pathing Special Files"
                   when 'MEDLIBUG' then "Media Librarian 1.2 User's Guide"
                   when 'MEDLIBADMIN' then "Media Librarian 1.2 Administrator's Guide"
                   when 'ETMUG' then "Enterprise Tape Manager 1.2 User's Guide"
                   when 'ETMADMIN' then "Enterprise Tape Manager 1.2 Administrator's Guide"
                   when 'ETMMLREFMAN1' then "man Pages(1): ETM/ML Commands"
                   when 'ETMMLREFMAN1M' then "man Pages(1M): ETM/ML Administration Commands"
                   when 'ETMMLREFMAN4' then "man Pages(4): ETM/ML File Formats"
                   when 'ETMMLREFMAN7' then "man Pages(7): ETM/ML Special Files"
                   when 'SMCCSWREFMAN' then "Solaris Reference Manual for SMCC-Specific Software"
          # non-Sun titles
                   when 'KR' then "The C Programming Language"
                   else "UNKNOWN TITLE ABBREVIATION: #{args[0]}".tap { |x| warn "Tz => #{x}" }
                   end
          )
    parse "\\fI\\*(Tz\\f1#{args[1]}"
  end

  define_method 'HC' do |*args|
    req_ds('Hc ' + case args[0]
          # Hard Copy Docs Only
                   when 'HC_DRIVERINSTALL' then "Driver Developer Kit Installation Guide"
                   when 'HC_OPENNEWSDDR' then "Driver Developer Kit Open Issues and Late-Breaking News"
                   when 'HC_ENCRYPTINST' then "Encryption Kit Installation Guide"
                   when 'HC_SPARCHW' then "SPARC Hardware Platform Guide"
                   when 'HC_OPENNEWSUSER' then "Solaris 2.5 Open Issues and Late-Breaking News"
                   when 'HC_x86DUG' then "Solaris 2.5 x86 Driver Update Guide"
                   when 'HC_x86HW' then "Hardware Compatibility List for Solaris 2.6 (Intel Platform Edition)"
                   when 'HC_ROADMAP' then "Solaris Roadmap"
                   when 'HC_MEDIAPREPGU' then "Source Installation and Media Preparation Guide"
                   when 'HC_SRCENCRYPT' then "Source Encryption Supplement"
                   when 'HC_HWCONFIG' then "x86 Device Configuration Guide"
          # STANDARDS Conformance Books. Hard copy only
                   when 'HC_POSIX1DOC' then "POSIX.1 CONFORMANCE DOCUMENT"
                   when 'HC_POSIX2DOC' then "POSIX.2 CONFORMANCE DOCUMENT"
                   when 'HC_XOPCDEDOC' then "X/OPEN COMMON DESKTOP ENVIRONMENT CONFORMANCE DOCUMENT"
                   when 'HC_XOPUNIXDOC' then "X/OPEN UNIX CONFORMANCE DOCUMENT"
                   when 'HC_XOPXPG3DOC' then "X/OPEN XPG3 CONFORMANCE DOCUMENT"
                   when 'HC_RSMARNOTES' then "Product Notes: Sun RSM Array 2000 Software"
                   else "UNKNOWN TITLE ABBREVIATION: #{args[0]}".tap { |x| warn "Hc => #{x}" }
                   end
          )
    parse "\\fI\\*(Hc\\f1#{args[1]}"
  end

end
