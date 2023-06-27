# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/11/23.
# Copyright 2023 Typewritten Software. All rights reserved.
#
#
# Solaris 2.1 Platform Overrides
#
#

module SunOS_5_1

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

  def init_sunos51
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
                   when 'APDEVGUIDE' then "Solaris 2.1 Application Developer's Guide"
                   when 'APDEVTRANS' then "Solaris 2.1 Transition Guide"
                   when 'ASPA' then "SunOS 5.1 Administering Security, Performance, and Accounting"
                   when 'BINARY' then "Binary Compatibility Package Guide \\- Solaris 2.1"
                   when 'CUIETI' then "SunOS 5.1 Character User Interface: Extended Terminal Interface"
                   when 'CUIFMLI' then "SunOS 5.1 Character User Interface: Form and Menu Language Interpreter"
                   when 'DDADD' then "SunOS 5.1 Adding and Maintaining Devices and Drivers"
                   when 'DOCS' then "SunOS 5.1 Formatting Documents"
                   when 'DRIVER' then "SunOS 5.1 Writing Device Drivers"
                   when 'GS' then "Solaris 2.1 Getting Started"
                   when 'HANDBOOK' then "Solaris 2.x Handbook for SMCC Peripherals"
                   when 'HOWTO' then "SunOS 5.1 How-To Book: Basic System Administration Tasks"
                   when 'I18N' then "Solaris 2.1 Developer's Guide to Internationalization"
                   when 'INSTALL' then "Solaris 2.1 System Configuration and Installation Guide"
                   when 'LLM' then "SunOS 5.1 Linker and Libraries Manual"
                   when 'NETCOM' then "SunOS 5.1 Administering TCP/IP and UUCP"
                   when 'NETNAME' then "SunOS 5.1 Administering NIS+ and DNS"
                   when 'NETP' then "SunOS 5.1 Network Interfaces Programmer's Guide"
                   when 'NETSHARE' then "SunOS 5.1 Administering NFS and RFS"
                   when 'OSUG' then "SunOS 5.1 User's Guide"
                   when 'OWDESKSET' then "OpenWindows Version 3.1 DeskSet Reference Guide"
                   when 'OWDIG' then "OpenWindows Version 3.1 Desktop Integration Guide"
                   when 'OWPG' then "OpenWindows Version 3.1 Programmer's Guide"
                   when 'OWREFMAN' then "OpenWindows Version 3.1 Reference Manual"
                   when 'OWUG' then "OpenWindows Version 3.1 User's Guide"
                   when 'PACKINSTALL' then "SunOS 5.1 Application Packaging and Installation Guide"
                   when 'PROGUTILS' then "SunOS 5.1 Programming Utilities "
                   when 'REALTIME' then "SunOS 5.1 Realtime Programmer's and Administrator's Guide"
                   when 'REFMAN1' then "SunOS 5.1 Reference Manual"
                   when 'REFMAN1M' then "SunOS 5.1 Reference Manual"
                   when 'REFMAN2' then "SunOS 5.1 Reference Manual"
                   when 'REFMAN3' then "SunOS 5.1 Reference Manual"
                   when 'REFMAN3M' then "SunOS 5.1 Reference Manual"
                   when 'REFMAN4' then "SunOS 5.1 Reference Manual"
                   when 'REFMAN5' then "SunOS 5.1 Reference Manual"
                   when 'REFMAN6' then "SunOS 5.1 Reference Manual"
                   when 'REFMAN7' then "SunOS 5.1 Reference Manual"
                   when 'REFMAN8' then "SunOS 5.1 Reference Manual"
                   when 'REFMAN9E' then "SunOS 5.1 Reference Manual"
                   when 'REFMAN9F' then "SunOS 5.1 Reference Manual"
                   when 'REFMAN9S' then "SunOS 5.1 Reference Manual"
                   when 'RELEASE' then "Solaris 2.1 Release ManuaL"
                   when 'ROADMAP' then "Solaris 2.1 Roadmap to Documentation"
                   when 'RSAG' then "SunOS 5.1 Routine System Administration Guide"
                   when 'SMAG' then "Solaris 2.1 Software Manager Administrator's Guide"
                   when 'SOURCE' then "SunOS/BSD Source Compatibility Package Guide \\- SunOS 5.1"
                   when 'SPARC' then "SunOS 5.1 SPARC Assembly Language Reference Manual"
                   when 'SS' then "SunOS 5.1 System Services"
                   when 'STANDARDS' then "Solaris 2.1 Standards Conformance Guide"
                   when 'STREAMS' then "SunOS 5.1 STREAMS Programmer's Guide"
                   when 'SUNDIAG' then "Sundiag 4.1 User's Guide"
                   when 'SUNDIAGADD' then "Sundiag 4.1 User's Guide - Addendum for SMCC Hardware"
                   when 'SUUPAM' then "SunOS 5.1 Setting Up User Accounts, Printers and Mail"
                   when 'SYSADTRANS' then "Solaris 2.1 Transition Guide"
                   when 'TEXT' then "SunOS 5.1 Editing Text Files"
                   when 'TROFF' then "SunOS 5.1 Using nroff and troff"
                   when 'TTPG' then "ToolTalk 1.0.2 Programmer's Guide"
                   when 'TTSAG' then "ToolTalk 1.0.2 Setup and Administration Guide"
                   when 'USERTRANS' then "Solaris 2.1 Transition Guide"
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
                   when 'C2PG' then "SPARCompiler C 2.0.1 Programmers Guide"
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
