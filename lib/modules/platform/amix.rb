# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/16/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Amiga SVR4 Platform Overrides
#
# TODO
#   type clashes in openlook entries - can't parse title
#

module AMIX
  class Nroff < Nroff
    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.(\d\S*?)?(?:\.?[Zz])?$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      super(source, **kwargs)
    end
  end

  class Troff < Troff::Man
    alias :LP :P

    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.Z$/, '')
      super(source, **kwargs)
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          #'Tm' => '&trade;',
          ']W' => 'Amiga Unix',
          footer: String.new('\\*(]W\\0\\0\\(em\\0\\0\\*(]L')
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

    # .so with absolute path, headers in /usr/include
    def so(name, breaking: nil, basedir: nil)
      basedir = "#{@source.dir}#{"/../.." if name.start_with?('/')}"
      super(name, breaking: breaking, basedir: basedir)
    end

    def TH(*args)
      heading = "#{args[0]}\\|(\\|#{args[1]}\\|)\\0\\0\\(em\\0\\0\\*(]D"
      ds("]D #{MANUAL_SECTION_NAMES[args[1]]}")
      ds("]L Last change: #{args[2]}")
      ds("]W #{args[4]}") if args[4] and !args[4].empty?
      ds("]D #{args[5]}") if args[5] and !args[5].empty?

      super(*args, heading: heading)
    end

    def TX(*args)
      ds("Tx #{MANUAL_NAMES[args[0]]}")
      parse "\\fI\\*(Tx\\fP#{args[1]}"
    end

    # some pages call this, but the def is commented out
    # defining it as a no-op suppresses the warning.
    def UC(*_args) ; end

    # good news - margin characters don't seem to be used anywhere in the Sun manual
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
    'DOCBOX'   => "Documentation Set",
    'BGBOX'    => "Beginner's Guides Minibox",
    'GSBG'     => "Getting Started with Amiga Unix: Beginner's Guide",
    'SUBG'     => "Setting Up Your Amiga Unix Environment: Beginner's Guide",
    'SHBG'     => "Self Help with Problems: Beginner's Guide",
    'SVBG'     => "SunView\\ 1 Beginner's Guide",
    'MMBG'     => "Mail and Messages: Beginner's Guide",
    'DMBG'     => "Doing More with Amiga Unix: Beginner's Guide",
    'UNBG'     => "Using the Network: Beginner's Guide",
    'GDBG'     => "Games, Demos & Other Pursuits",
    'SABOX'    => "System Administration Manuals Minibox",
    'CHANGE'   => "Release 4.0 Change Notes",
    'INSTALL'  => "Installing Amiga Unix",
    'ADMIN'    => "System and Network Administration",
    'SECUR'    => "Security Features Guide",
    'PROM'     => "PROM User's Manual",
    'DIAG'     => "Amiga Unix System Diagnostics Manual",
    'SUNDIAG'  => "Sundiag User's Guide",
    'REFBOX'   => "Reference Manuals Minibox",
    'MANPAGES' => "Amiga Unix Reference Manual",
    'REFMAN'   => "Amiga Unix Reference Manual",
    'SSI'      => "Amiga Unix System Introduction",
    'SSO'      => "System Services Overview",
    'TEXT'     => "Editing Text Files",
    'DOCS'     => "Formatting Documents",
    'TROFF'    => "Using \\&\\fLnroff\\fP and \\&\\fLtroff\\fP",
    'INDEX'    => "Global Index",
    'PTBOX'    => "Programmer's Tools Manuals Minibox",
    'CPG'      => "C Programmer's Guide",
    'CREF'     => "C Reference Manual",
    'ASSY'     => "Assembly Language Manual",
    'PUL'      => "Programming Utilities and Libraries",
    'DEBUG'    => "Debugging Tools",
    'NETP'     => "Network Programming",
    'DRIVER'   => "Writing Device Drivers",
    'FPOINT'   => "Floating Point Programmers Guide",
    'SVPG'     => "SunView\\ 1 Programmer's Guide",
    'SVSPG'    => "SunView\\ 1 System Programmer's Guide",
    'PIXRCT'   => "Pixrect Reference Manual",
    'CGI'      => "SunCGI Reference Manual",
    'CORE'     => "Amiga Unix Core Reference Manual",
    '4ASSY'    => "Sun-4 Assembly Language Reference Manual",
                        # non-Sun titles
    'KR'       => "The C Programming Language"
  }

  # names from tmac.an .TH - we don't want these for the index though
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
    '3V' => 'SYSTEM V LIBRARY',
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
    '7'  => 'PUBLIC FILES, TABLES, AND TROFF MACROS',
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

  # these are our display names, used by the indexer
  def self.name_for_section(sec)
    case sec.downcase
    when '1'    then "<strong>#{sec}.</strong> User Commands"
    when '1a'   then "<strong>#{sec}.</strong> Amiga-specific Commands"
    when '1c'   then "<strong>#{sec}.</strong> Communications Commands"
    when '1f'   then "<strong>#{sec}.</strong> FMLI Commands"
    when '1g'   then "<strong>#{sec}.</strong> Graphics Commands"
    when '1l'   then "<strong>#{sec}.</strong> Local Commands"
    when '1m'   then "<strong>#{sec}.</strong> Maintenance Commands"
    when '2'    then "<strong>#{sec}.</strong> System Calls"
    when '3'    then "<strong>#{sec}.</strong> C Library Functions"
    when '3a'   then "<strong>#{sec}.</strong> Amiga-specific Functions"
    when '3c'   then "<strong>#{sec}.</strong> Compatibility Functions"
    when '3e'   then "<strong>#{sec}.</strong> ELF Library"
    when '3g'   then "<strong>#{sec}.</strong> General Purpose Library"
    when '3m'   then "<strong>#{sec}.</strong> Mathematical Library"
    when '3n'   then "<strong>#{sec}.</strong> Network Support Library"
    when '3s'   then "<strong>#{sec}.</strong> Standard I/O Functions"
    when '3x'   then "<strong>#{sec}.</strong> Miscellaneous Library Functions"
    when '3x11' then "<strong>#{sec}.</strong> X11 Library"
    when '3xt'  then "<strong>#{sec}.</strong> X Toolkit"
    when '4'    then "<strong>#{sec}.</strong> Devices and Network Interfaces"
    when '5'    then "<strong>#{sec}.</strong> File Formats"
    when '5a'   then "<strong>#{sec}.</strong> Amiga-specific File Formats"
    when '6'    then "<strong>#{sec}.</strong> Games and Demos"
    when '7'    then "<strong>#{sec}.</strong> Public Files, Tables, and Troff Macros"
    when '7a'   then "<strong>#{sec}.</strong> Amiga-specific Devices"
    when '8'    then "<strong>#{sec}.</strong> Maintenance Commands"
    when '8c'   then "<strong>#{sec}.</strong> Communications Maintenance Commands"
    when '8l'   then "<strong>#{sec}.</strong> Local Maintenance Commands"
    when 'l'    then 'Local Commands'
    else "Section #{sec}"
    end
  end
end
