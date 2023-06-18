# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 06/11/23.
# Copyright 2023 Typewritten Software. All rights reserved.
#
#
# Solaris 2.4 Platform Overrides
#
#

module SunOS_5_4

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
    @state[:named_string].merge!({
      ']W' => "SunOS #{@version}",
      '||' => '/usr/share/lib/tmac'
    })
  end

  def init_fp
    # Palatino family for postscript output (PA, PI, PB)
    super
    @state[:fonts][4] = 'B'
    @state[:fonts][5] = 'R'
    @state[:fonts][6] = 'B'
  end

  def init_sunos54
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
      '3k' => 'Kernel VM Library Functions',
      '3l' => 'Lightweight Processes Library',
      '3m' => 'Mathematical Library',
      '3n' => 'Network Functions',
      '3r' => 'Realtime Library',
      '3s' => 'Standard I/O Functions',
      '3t' => 'Thread Library',
      '3w' => 'C Library Functions',
      '3x' => 'Miscellaneous Library Functions',
      '3xc' => 'X/Open Curses Library Functions',
      '3xn' => 'X/Open Networking Services Library Functions',
      '4'  => 'File Formats',
      '4b' => 'SunOS/BSD Compatibility Package File Formats',
      '5'  => 'Headers, Environments, and Macros',
      '6'  => 'Games and Demos',
      '7'  => 'Special Files',
      '7b' => 'SunOS/BSD Compatibility Special Files',
      '8'  => 'Maintenance Procedures',
      '8c' => 'Maintenance Procedures',
      '8s' => 'Maintenance Procedures',
      '9'  => 'DDI and DKI',
      '9e' => 'DDI and DKI Driver Entry Points',
      '9f' => 'DDI and DKI Kernel Functions',
      '9s' => 'DDI and DKI Data Structures',
      'l'  => 'Local Commands'
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
                   when 'ABADMIN' then "Software and AnswerBook Packages Administration Guide"
                   when 'ADMINREF' then "Administration Application Reference Manual"
                   when 'ADMINSUPP' then "Administration Supplement for Solaris Platforms"
                   when 'ADVOSUG' then "Solaris Advanced User's Guide"
                   when 'ASPA' then "Security, Performance, and Accounting Administration"
                   when 'BINARY' then "Solaris Binary Compatibility Guide"
                   when 'CAT' then "Common Administration Tasks"
                   when 'DDADD' then "Peripherals Administration"
                   when 'DIRXLIBUG' then "Direct Xlib User's Guide"
                   when 'DRIVER' then "Writing Device Drivers"
                   when 'FCODE' then "Writing FCode Programs"
                   when 'I18N' then "Developer's Guide to Internationalization"
                   when 'INTRODEV' then "Software Developer Kit Introduction"
                   when 'INTRODRIVER' then "Driver Developer Kit Introduction"
                   when 'INTROUSER' then "Solaris 2.4 Introduction"
                   when 'LLM' then "Linker and Libraries Guide"
                   when 'MOTIFTRANS' then "OPENLOOK to Motif GUI Transition Guide"
                   when 'MTP' then "Multithreaded Programming"
                   when 'NETCOM' then "TCP/IP Network Administration Guide"
                   when 'NETNAME' then "Name Services Administration Guide"
                   when 'NETP' then "Network Interfaces Programmer's Guide"
                   when 'NETSHARE' then "NFS Administration Guide"
                   when 'NETTRANS' then "NIS+ Transition Guide"
                   when 'NISQSTART' then "Name Service Setup and Configuration Guide"
                   when 'OLITREF' then "OLIT Reference Manual"
                   when 'OLITSTART' then "OLIT QuickStart Programmer's Guide"
                   when 'OPENBOOTCMDREF' then "OpenBoot Command Reference Manual"
                   when 'OWDDG' then "OpenWindows Server Device Developer's Guide"
                   when 'OWPG' then "OpenWindows Server Programmer's Guide"
                   when 'OWREFMAN' then "OpenWindows Reference Manual"
                   when 'PACKINSTALL' then "Application Packaging Developer's Guide"
                   when 'PROGUTILS' then "Programming Utilities Guide"
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
                   when 'RSAG' then "File System Administration"
                   when 'SHIELD' then "SunSHIELD Basic Security Module Guide"
                   when 'SOURCE' then "Solaris Source Compatibility Guide"
                   when 'SPARC' then "SPARC Assembly Language Reference Manual"
                   when 'SPARCINSTALL' then "SPARC: Installing Solaris Software"
                   when 'SS' then "System Services Guide"
                   when 'SSDIG' then "Desktop Integration Guide"
                   when 'SSUG' then "Solaris User's Guide"
                   when 'STANDARDS' then "Standards Conformance Reference Manual"
                   when 'STREAMS' then "STREAMS Programmer's Guide"
                   when 'SUNDIAG' then "SunDiag User's Guide"
                   when 'SUUPAM' then "User Accounts, Printers, and Mail Administration"
                   when 'SVCONVERT' then "XView Developer's Notes"
                   when 'TELEOVERVIEW' then "XTL Architecture Guide"
                   when 'TRANSITION' then "Solaris 1.x to Solaris 2.x Transition Guide"
                   when 'TTREF' then "ToolTalk Reference Manual"
                   when 'TTUG' then "ToolTalk User's Guide"
                   when 'XTELADMIN' then "XTL Administrator's Guide"
                   when 'XTELPG' then "XTL Application Programmer's Guide"
                   when 'XTELPROVIDER' then "XTL Provider Programmer's Guide"
                   when 'x86' then "x86 Assembly Language Reference Manual"
                   when 'x86INSTALL' then "x86: Installing Solaris Software"
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
                   when 'XVIEWCODEGEN' then "OpenWindows Developer's Guide: XView Code Generator Programmer's Guide"
                   when 'OLITCODEGEN' then "OpenWindows Developer's Guide: OLIT Code Generator Programmer's Guide"
                   when 'DEVGUIDEUG' then "OpenWindows Developer's Guide: User's Guide"
                   when 'MOTIFUTIL' then "OpenWindows Developer's Guide: Motif Conversion Utilities Guide"
          # XGL
                   when 'XGLARCH' then "XGL Architecture Guide"
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
                   when 'HC_DEVINSTALL' then "Software Developer Kit Installation Guide"
                   when 'HC_OPENNEWSDEV' then "Software Developer Kit Open Issues and Late-Breaking News"
                   when 'HC_OPENNEWSUSER' then "Solaris 2.4 Open Issues and Late-Breaking News"
                   when 'HC_x86DUG' then "Solaris 2.4 x86 Driver Update Guide"
                   when 'HC_x86HW' then "Solaris 2.4 x86 Hardware Compatibility List"
                   when 'HC_DESKSETQREF' then "Solaris QuickStart Guide"
                   when 'HC_ROADMAP' then "Solaris Roadmap"
                   when 'HC_MEDIAPREPGU' then "Solaris Source Installation and Media Preparation Guide"
                   when 'HC_SRCENCRYPT' then "Source Encryption Supplement"
                   when 'HC_HWCONFIG' then "x86 Device Configuration Guide"
                   else "UNKNOWN TITLE ABBREVIATION: #{args[0]}".tap { |x| warn "Hc => #{x}" }
                   end
    )
    parse "\\fI\\*(Hc\\f1#{args[1]}"
  end

end
