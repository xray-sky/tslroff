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

class OS_MP
  class Troff < Troff

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

    alias :LP :P

    def initialize(source)
      @manual_entry ||= source.file.sub(/\.(\d\S*)$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      super(source)
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          #'Tm' => '&trade;',
          ']W' => 'Solbourne Computer, Inc.',
          footer: "\\*(]W"
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
    define_method 'IX' do |*_args| ; end

    define_method 'SB' do |*args|
      parse "\\&\\fB\\s-1\\&#{args[0..5].join(' ')}\\s0\\fR"
    end

    define_method 'TH' do |*args|
      ds "]D #{MANUAL_SECTION_NAMES[args[1]]}"
      ds "]L #{args[2]}"
      ds "]W #{args[3]}" if args[3] and !args[3].strip.empty?
      ds "]D #{args[4]}" if args[4] and !args[4].strip.empty?

      @named_strings[:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @named_strings[']L'].empty?
      heading = "#{args[0]}\\|(\\|#{args[1]}\\|)\\0\\0\\(em\\0\\0\\*(]D"

      super(*args, heading: heading)
    end

    define_method 'TX' do |*args|
      ds "Tx #{MANUAL_NAMES[args[0]]}"
      parse "\\fI\\*(Tx\\f1#{args[1]}"
    end

    # some pages call this, but the def is commented out all the way back to 0.3
    # defining it as a no-op suppresses the warning.
    define_method 'UC' do |*_args| ; end

    define_method 'VE' do |*args|
      # .if '\\$1'4' .mc \s12\(br\s0
      # draws a 12pt box rule as right margin character
      warn "can't yet .VE #{args.inspect}"
    end

    define_method 'VS' do |*args|
      # .mc
      # clears box rule margin character
      warn "can't yet .VS #{args.inspect}"
    end
  end
end
