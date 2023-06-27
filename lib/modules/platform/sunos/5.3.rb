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

module SunOS_5_3

  def self.extended(k)
    case k.instance_variable_get '@input_filename'
    when 'aspppls.1m'
      raise ManualIsBlacklisted, 'pathological use of .so'
    #  k.instance_variable_get('@source').lines[767].sub!(/\\h/, 'h')
    #when 'a.out.4' # h4x: collapsed tbl cells due to line-height:0 from \u...\d
    #  k.instance_variable_get('@source').lines[54].sub!(/(\\u.+?\\d)/, '\\ \1\\ ')
    #  k.instance_variable_get('@source').lines[58].sub!(/(\\u.+?\\d)/, '\\ \1\\ ')
    #  k.instance_variable_get('@source').lines[60].gsub!(/(\\u.+?\\d)/, '\\ \1\\ ')
    #when 'ar.4' # h4x: missing single quote in input; not sure how troff copes - perhaps \(ga matches ' ?? ugh... TODO
    #  k.instance_variable_get('@source').lines[41].sub!(/\\h\\\(ga/, "\\h'")
    end
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

  def init_sunos53
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
    @state[:named_string][:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @state[:named_string][']L'].empty?

    super(heading: heading)
  end

  define_method 'TZ' do |*args|
    req_ds('Tz ' + case args[0]
                   when 'ABADMIN' then "Solaris 2.3 AnswerBook  Administration Guide"
                   when 'ADMINUG' then "SunOS 5.3 User's Guide to System Administration"
                   when 'ADVOSUG' then "Solaris 2.3 Advanced User's Guide"
                   when 'ASPA' then "Solaris 2.3 Administering Security, Performance, and Accounting"
                   when 'BACKUP' then "Online: Backup 2.1 Administration Guide"
                   when 'BINARY' then "Solaris 2.3 Binary Compatibility Guide"
                   when 'DDADD' then "Solaris 2.3 Adding and Maintaining Peripherals"
                   when 'DEVGUIDEUIBUILD' then "OpenWindows Developer's Guide 3.3: A User Interface Builder"
                   when 'DIRXLIBUG' then "Direct Xlib 3.0 User's Guide"
                   when 'DRIVER' then "SunOS 5.3 Writing Device Drivers"
                   when 'I18N' then "Solaris 2.3 Developer's Guide to Internationalization"
                   when 'INSTALL' then "Solaris 2.3 System Configuration and Installation Guide"
                   when 'L10N' then "Solaris 2.3 Localization Guide"
                   when 'LLM' then "SunOS 5.3 Linker and Libraries Manual"
                   when 'MTP' then "SunOS 5.3 Guide to Multi-Thread Programming"
                   when 'NETCOM' then "SunOS 5.3 Administering TCP/IP and PPP"
                   when 'NETNAME' then "SunOS 5.3 Administering NIS+ and DNS"
                   when 'NETP' then "SunOS 5.3 Network Interfaces Programmer's Guide"
                   when 'NETSHARE' then "SunOS 5.3 Administering NFS"
                   when 'NEWFEATURES' then "Solaris 2.3 New Features"
                   when 'OLITREF' then "OLIT 3.2 Reference Manual"
                   when 'OLITSTART' then "OLIT Getting Started Guide"
                   when 'OWPG' then "OpenWindows 3.3 Programmer's Guide"
                   when 'OWREFMAN' then "OpenWindows 3.3 Reference Manual"
                   when 'PACKINSTALL' then "Solaris 2.3 Developer's Guide to Application Packaging"
                   when 'PROGUTILS' then "SunOS 5.3 Programming Utilities"
                   when 'REFMAN1' then "man Pages(1): User Commands"
                   when 'REFMAN1M' then "man Pages(1M): System Administration Commands"
                   when 'REFMAN2' then "man Pages(2): System Calls"
                   when 'REFMAN3' then "man Pages(3): Library Routines"
                   when 'REFMAN4' then "man Pages(4): File Formats"
                   when 'REFMAN5' then "man Pages(5): Headers, Tables and Macros"
                   when 'REFMAN6' then "man Pages(6): Demos"
                   when 'REFMAN7' then "man Pages(7): Special Files"
                   when 'REFMAN9' then "man Pages(9): DDI and DKI Overview"
                   when 'REFMAN9E' then "man Pages(9E): DDI and DKI Driver Entry Points"
                   when 'REFMAN9F' then "man Pages(9F): DDI and DKI Kernel Functions"
                   when 'REFMAN9S' then "man Pages(9S): DDI and DKI Data Structures"
                   when 'RELEASE' then "Solaris 2.3 Release Manual"
                   when 'ROADMAP' then "Solaris 2.3 Roadmap to Documentation"
                   when 'RSAG' then "Solaris 2.3 Administering File Systems"
                   when 'SHIELD' then "Solaris SHIELD Basic Security Module"
                   when 'SMAG' then "Solaris 2.3 Software Manager User's Guide"
                   when 'SOURCE' then "Solaris 2.3 Source Compatibility Manual"
                   when 'SPARC' then "SunOS 5.3 SPARC Assembly Language Reference Manual"
                   when 'SS' then "SunOS 5.3 System Services"
                   when 'SSDIG' then "Solaris 2.3 Desktop Integration Guide"
                   when 'SSUG' then "Solaris 2.3 User's Guide"
                   when 'STANDARDS' then "Solaris 2.3 Standards Conformance Guide"
                   when 'STREAMS' then "SunOS 5.3 STREAMS Programmer's Guide"
                   when 'SUNDIAG' then "SunDiag 4.3 User's Guide"
                   when 'SUUPAM' then "Solaris 2.3 Adding User Accounts, Printers, and Mail"
                   when 'SVCONVERT' then "XView 3.2 Developer's Notes"
                   when 'TRANSITION' then "Solaris 2.3 Transition Guide"
                   when 'TTREF' then "ToolTalk 1.1.1 Reference Manual"
                   when 'TTUG' then "ToolTalk 1.1.1 User's Guide"
                   when 'x86' then "SunOS 5.3 x86 Assembly Language Reference Manual"
                   when 'x86INSTALL' then "x86: Installing Solaris Software"
          # SPARCstorage Array
                   when 'VOLMGRREFMAN' then "Manpages For The Volume Manager"
                   when 'ARRAYCONFG' then "SPARCstorage Array Configuration Guide"
                   when 'ARRAYUG' then "SPARCstorage Array User's Guide"
          # SPARCworks
                   when 'BROWSESC' then "Browsing Source Code"
                   when 'DEBUGAPROG' then "Debugging a Program"
                   when 'TOOLSET' then "Managing SPARCworks Tools"
                   when 'MAKETOOL' then "Building Programs with MakeTool"
                   when 'MERGE' then "Merging Source Files"
                   when 'PERFTUNAPP' then "Performance-Tuning an Application"
                   when 'SPARCWTR' then "Introduction to SPARCworks"
          # Languages - C
                   when 'C2PG' then "SPARCompiler C 2.0.1 Programmer's Guide"
                   when 'CLIBREF' then "SPARCompiler C 2.0.1 Libraries Reference Manual"
                   when 'CTRANGUIDE' then "SPARCompiler C 2.0.1 Transition Guide"
          # Languages - C++
                   when 'CPPLIBMAN' then "SPARCompiler C++ 3.0.1 Language System Library Manual"
                   when 'CPPREF' then "SPARCompiler C++ 3.0.1 Language System Product Reference Manual"
                   when 'CPPPG' then "SPARCompiler C++ 3.0.1 Programmers Guide"
                   when 'CPPRN' then "SPARCompiler C++ 3.0.1 Language System Release Notes"
                   when 'CPPREADINGS' then "SPARCompiler C++ 3.0.1 Language System Selected Readings"
          # Languages - Fortran
                   when 'FORTRANREF' then "SPARCompiler FORTRAN 2.0.1 Reference Manual"
                   when 'FORTRANUG' then "SPARCompiler FORTRAN 2.0.1 Users Guide"
          # Languages - Pascal
                   when 'PASCALREF' then "SPARCompiler Pascal 3.0.1 Reference Manual"
                   when 'PASCALUG' then "SPARCompiler Pascal 3.0.1 User Guide"
          # Languages - Common to all
                   when 'NUMCOMPGD' then "Numerical Computation Guide"
                   when 'PROGTOOLS' then "Programming Tools"
                   when 'SWSC1' then "Installing SPARCworks and SPARCompilers Software for Solaris 1.x"
                   when 'SWSC2' then "Installing SunPro Software on Solaris"
          # DiagExec
                   when 'BASICSDIAG' then "Basic System Diagnostics"
                   when 'GRAPHDIAG' then "Graphics Diagnostics"
                   when 'NETDIAG' then "Networking Diagnostics"
                   when 'PERIPHDIAG' then "Peripheral Diagnostics"
                   when 'SDIAGEXECPG' then "SunDiagnostic Executive Programmer's Guide"
                   when 'SDIAGEXECUG' then "Using the SunDiagnostic Executive"
                   when 'SDIAGEXECINST' then "SunDiagnostics Answerbook Install"
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
                   when 'TNTCODEGEN' then "OpenWindows Developer's Guide: Programmer's Guide to The NewS Toolkit 3.0.1 Code Generator"
                   when 'XVIEWCODEGEN' then "OpenWindows Developer's Guide: Programmer's Guide to the XView 3.0.1 Toolkit Code Generator"
                   when 'OLITCODEGEN' then "OpenWindows Developer's Guide: Programmer's Guide to the OLIT 3.0.1 Code Generator"
                   when 'DEVGUIDEUG' then "OpenWindows Developer's Guide 3.0.1 User's Guide"
          # non-Sun titles
                   when 'KR' then "The C Programming Language"
                   else "UNKNOWN TITLE ABBREVIATION: #{args[0]}".tap { |x| warn "Tz => #{x}" }
                   end
          )
    parse "\\fI\\*(Tz\\f1#{args[1]}"
  end

end
