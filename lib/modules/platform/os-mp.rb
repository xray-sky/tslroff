# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Solbourne OS/MP Platform Overrides
#
# TODO
#   some strange doings in section 3 of the OW3.0 manual
#

module OS_MP
  class Nroff < Nroff
    def initialize(source, **kwargs)
      case source.file
      when 'ce_db_build.1', 'ce_db_merge.1' # no title line
        @manual_section = '1'
        @manual_entry = (source.file)[0..-3]
        # TODO also has see also link w/ whitespace (e.g. "ref (section)")
      end
      super(source, **kwargs)
      @lines_per_page = nil
    end
  end

  class Troff < Troff::Man
    alias :LP :P

    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.(\d\S*)$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      super(source, **kwargs)
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          #'Tm' => '&trade;',
          ']W' => 'Solbourne Computer, Inc.',
          footer: "\\*(]W".+@
        }
      )
    end

    def init_tr
      super
      @character_translations['*'] = "\e(**"
    end

    def init_TH
      #super
      @register['IN'] = Troff::Register.new(@base_indent)
    end

    # index info - what even makes sense to do with this
    def IX(*_args) ; end

    def SB(*args)
      parse "\\&\\fB\\s-1\\&#{args[0..5].join(' ')}\\s0\\fR"
    end

    def TH(*args)
      ds "]D #{MANUAL_SECTION_NAMES[args[1]]}"
      ds "]L #{args[2]}"
      ds "]W #{args[3]}" if args[3] and !args[3].strip.empty?
      ds "]D #{args[4]}" if args[4] and !args[4].strip.empty?

      @named_strings[:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @named_strings[']L'].empty?
      heading = "#{args[0]}\\|(\\|#{args[1]}\\|)\\0\\0\\(em\\0\\0\\*(]D"

      super(*args, heading: heading)
    end

    def TX(*args)
      ds "Tx #{MANUAL_NAMES[args[0]]}"
      parse "\\fI\\*(Tx\\f1#{args[1]}"
    end

    # some pages call this, but the def is commented out all the way back to 0.3
    # defining it as a no-op suppresses the warning.
    def UC(*_args) ; end

    def VE(*args)
      # .if '\\$1'4' .mc \s12\(br\s0
      # draws a 12pt box rule as right margin character
      warn "can't yet .VE #{args.inspect}"
    end

    def VS(*args)
      # .mc
      # clears box rule margin character
      warn "can't yet .VS #{args.inspect}"
    end
  end

  MANUAL_NAMES = {
    'DOCBOX'   => 'Documentation Set',
    'BGBOX'    => 'Beginner\'s Guides',
    'GSBG'     => 'Getting Started with OS/MP: Beginner\'s Guide',
    'SUBG'     => 'Setting Up Your OS/MP Environment: Beginner\'s Guide',
    'SHBG'     => 'Self Help with Problems: Beginner\'s Guide',
    'SVBG'     => 'SunView\ 1 User\'s Guide',
    'MMBG'     => 'Mail and Messages',
    'DMBG'     => 'Doing More with OS/MP: Beginner\'s Guide',
    'UNBG'     => 'Using the Network Beginner\'s Guide',
    'GDBG'     => 'Games, Demos & Other Pursuits',
    'SABOX'    => 'Administration Guides',
    'CHANGE'   => 'OS/MP Release Notes',
    'INSTALL'  => 'OS/MP Release Notes',
    'ADMIN'    => 'System and Network Administration',
    'SECUR'    => 'Security Features Guide',
    'PROM'     => 'PROM User\'s Manual',
    'DIAG'     => 'Solbourne System Diagnostics Manual',
    'SUNDIAG'  => 'Sundiag User\'s Guide',
    'MANPAGES' => 'UNIX User\'s Reference Manual',
    'REFMAN'   => 'UNIX Programmer\'s Reference Manual',
    'SSI'      => 'Series4 and Series5 Hardware Overview',
    'SSO'      => 'Solbourne System Services Overview',
    'TEXT'     => 'Editing Text Files',
    'DOCS'     => 'Formatting Documents',
    'TROFF'    => 'Using \\&\\fBnroff\\fP and \\&\\fBtroff\\fP',
    'INDEX'    => 'on-line help \\f3lookup\\f1\\|(1)',
    'CPG'      => 'C Programmer\'s Guide',
    'CREF'     => 'C Reference Manual',
    'ASSY'     => 'Assembly Language Manual',
    'PUL'      => 'Programming Utilities and Libraries',
    'DEBUG'    => 'Debugging Tools',
    'NETP'     => 'Network Programming',
    'DRIVER'   => 'Solbourne Device Drivers Manual',
    'STREAMS'  => 'STREAMS Programming',
    'SBDK'     => 'SBus Developer\'s Kit',
    'WDDS'     => 'Writing Device Drivers for the SBus',
    'FPOINT'   => 'Floating-Point Programmer\'s Guide',
    'SVPG'     => 'SunView\\ 1 Programmer\'s Guide',
    'SVSPG'    => 'SunView\\ 1 System Programmer\'s Guide',
    'PIXRCT'   => 'Pixrect Reference Manual',
    'CGI'      => 'SunCGI Reference Manual',
    'CORE'     => 'SunCore Reference Manual',
    '4ASSY'    => 'Assembly Reference Manual',
    'SARCH'    => '\\s-1SPARC\\s0 Architecture Manual',
             # non-Sun titles
    'KR'       => 'The C Programming Language',
  }

  MANUAL_SECTION_NAMES = {
    '1'  => 'USER COMMANDS',
    '1C' => 'USER COMMANDS',
    '1G' => 'USER COMMANDS',
    '1S' => 'USER COMMANDS',
    '1V' => 'USER COMMANDS',
    '2'  => 'SYSTEM CALLS',
    '2V' => 'SYSTEM CALLS',
    '3'  => 'C LIBRARY FUNCTIONS',
    '3C' => 'COMPATIBILITY FUNCTIONS',
    '3F' => 'FORTRAN LIBRARY ROUTINES',
    '3K' => 'KERNEL VM LIBRARY FUNCTIONS',
    '3L' => 'LIGHTWEIGHT PROCESSES LIBRARY',
    '3M' => 'MATHEMATICAL LIBRARY',
    '3N' => 'NETWORK FUNCTIONS',
    '3R' => 'RPC SERVICES LIBRARY',
    '3S' => 'STANDARD I/O FUNCTIONS',
    '3V' => 'C LIBRARY FUNCTIONS',
    '3X' => 'MISCELLANEOUS LIBRARY FUNCTIONS',
    '4'  => 'DEVICES AND NETWORK INTERFACES',
    '4F' => 'PROTOCOL FAMILIES',
    '4I' => 'DEVICES AND NETWORK INTERFACES',
    '4M' => 'DEVICES AND NETWORK INTERFACES',
    '4N' => 'DEVICES AND NETWORK INTERFACES',
    '4P' => 'PROTOCOLS',
    '4S' => 'DEVICES AND NETWORK INTERFACES',
    '4V' => 'DEVICES AND NETWORK INTERFACES',
    '5'  => 'FILE FORMATS',
    '5V' => 'FILE FORMATS',
    '6'  => 'GAMES AND DEMOS',
    '7'  => 'ENVIRONMENTS, TABLES, AND TROFF MACROS',
    '7V' => 'ENVIRONMENTS, TABLES, AND TROFF MACROS',
    '8'  => 'MAINTENANCE COMMANDS',
    '8C' => 'MAINTENANCE COMMANDS',
    '8S' => 'MAINTENANCE COMMANDS',
    '8V' => 'MAINTENANCE COMMANDS',
    'L'  => 'LOCAL COMMANDS'
  }

  MANUAL_NAMES.default_proc = proc { |_h, k| "UNKNOWN TITLE ABBREVIATION: #{k}" }
  MANUAL_SECTION_NAMES.default = 'MISC REFERENCE MANUAL PAGES'

  MANUAL_NAMES.freeze
  MANUAL_SECTION_NAMES.freeze

  def self.name_for_section(sec)
    case sec.downcase
    when '1'    then "<strong>#{sec}.</strong> Commands"
    when '1c'   then "<strong>#{sec}.</strong> Communications Commands"
    when '1g'   then "<strong>#{sec}.</strong> Graphics Commands"
    when '1l'   then "<strong>#{sec}.</strong> Commands"
    when '1m'   then "<strong>#{sec}.</strong> System V Maintenance Commands"
    when '1v'   then "<strong>#{sec}.</strong> System V Commands"
    when '2'    then "<strong>#{sec}.</strong> System Calls"
    when '2v'   then "<strong>#{sec}.</strong> System V Calls"
    when '3'    then "<strong>#{sec}.</strong> C Library"
    when '3c'   then "<strong>#{sec}.</strong> Compatibility Routines"
    when '3f'   then "<strong>#{sec}.</strong> FORTRAN Library"
    when '3k'   then "<strong>#{sec}.</strong> Kernel VM Library Functions"
    when '3l'   then "<strong>#{sec}.</strong> Lightweight Processes Library"
    when '3m'   then "<strong>#{sec}.</strong> Math Library"
    when '3n'   then "<strong>#{sec}.</strong> Network Support Library"
    when '3r'   then "<strong>#{sec}.</strong> RPC Library"
    when '3s'   then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3v'   then "<strong>#{sec}.</strong> POSIX/System V Compatibility Routines"
    when '3w'   then "<strong>#{sec}.</strong> OLIT Library"
    when '3x'   then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '3x11' then "<strong>#{sec}.</strong> X11 Library"
    when '3xt'  then "<strong>#{sec}.</strong> X Toolkit"
    when '4'    then "<strong>#{sec}.</strong> Device Special Files"
    when '4f'   then "<strong>#{sec}.</strong> Network Protocol Families"
    when '4m'   then "<strong>#{sec}.</strong> STREAMS Module Files"
    when '4n'   then "<strong>#{sec}.</strong> Network Facilities"
    when '4p'   then "<strong>#{sec}.</strong> Network Protocols"
    when '4s'   then "<strong>#{sec}.</strong> Solbourne-specific Device Special Files"
    when '5'    then "<strong>#{sec}.</strong> File Formats"
    when '6'    then "<strong>#{sec}.</strong> Games and Demos"
    when '7'    then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '7v'   then "<strong>#{sec}.</strong> System V Miscellaneous Facilities"
    when '8'    then "<strong>#{sec}.</strong> Maintenance Commands"
    when '8c'   then "<strong>#{sec}.</strong> Network Services"
    when '8s'   then "<strong>#{sec}.</strong> Solbourne-specific Maintenance Commands"
    when '8v'   then "<strong>#{sec}.</strong> POSIX/System V Maintenance Commands"
    when 'l'    then "<strong>#{sec}.</strong> Local Commands"
    else "Section #{sec}"
    end
  end
end
