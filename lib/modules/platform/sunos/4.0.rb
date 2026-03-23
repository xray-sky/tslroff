# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/09/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# SunOS 4.0 Platform Overrides
#
# TODO
# √ \fL ? - "Geneva Light"
#   curses(3v) uses \z and \o to poor effect (REVIEW is \o failing in tbl context?)
#       these are meant to be line graphics characters; maybe rewrite them.
#       \z is not working because \(br is _supposed_ to output skinny and
# √     Overstrike centers within the box. maybe I need a different class for \z
#       ...same problems as terminfo(4) [SunOS 5.5.1]

class SunOS::V4_0
  class Troff < ::SunOS::Troff

    MANUAL_NAMES = {
      'DOCBOX'   => "Documentation Set",
      'BGBOX'    => "Beginner's Guides Minibox",
      'GSBG'     => "Getting Started with SunOS: Beginner's Guide",
      'SUBG'     => "Setting Up Your SunOS Environment: Beginner's Guide",
      'SHBG'     => "Self Help with Problems: Beginner's Guide",
      'SVBG'     => "SunView\\ 1 Beginner's Guide",
      'MMBG'     => "Mail and Messages: Beginner's Guide",
      'DMBG'     => "Doing More with SunOS: Beginner's Guide",
      'UNBG'     => "Using the Network: Beginner's Guide",
      'GDBG'     => "Games, Demos & Other Pursuits",
      'SABOX'    => "System Administration Manuals Minibox",
      'CHANGE'   => "Release 4.0 Change Notes",
      'INSTALL'  => "Installing the SunOS",
      'ADMIN'    => "System and Network Administration",
      'SECUR'    => "Security Features Guide",
      'PROM'     => "PROM User's Manual",
      'DIAG'     => "Sun System Diagnostics Manual",
      'REFBOX'   => "Reference Manuals Minibox",
      'MANPAGES' => "SunOS Reference Manual",
      'REFMAN'   => "SunOS Reference Manual",
      'SSI'      => "Sun System Introduction",
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
      'CORE'     => "SunCore Reference Manual",
      '4ASSY'    => "Sun-4 Assembly Language Reference Manual",
            # non-Sun titles
      'KR'       => "The C Programming Language"
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
      '3P' => 'SUNPHIGS LIBRARY', # unbundled
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
      '7P' => 'SUNPHIGS LIBRARY', # unbundled
      '8'  => 'MAINTENANCE COMMANDS',
      '8C' => 'MAINTENANCE COMMANDS',
      '8S' => 'MAINTENANCE COMMANDS',
      '8V' => 'MAINTENANCE COMMANDS',
      'L'  => 'LOCAL COMMANDS'
    }

    MANUAL_NAMES.default_proc = proc { |_h, k| "UNKNOWN TITLE ABBREVIATION: #{k}"}
    MANUAL_SECTION_NAMES.default = 'MISC. REFERENCE MANUAL PAGES'

    def source_init
      case @source.file
      when 'default.1' then @manual_entry = '_default'
      when 'index.3'   then @manual_entry = '_index'
      end
      super
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          ']W' => 'Sun Release 4.0'
        }
      )
    end

    define_method 'SB' do |*args|
      parse "\\&\\fB\\s-1\\&#{args[0..5].join(' ')}\\s0\\fR"
    end

    define_method 'TH' do |*args|
      ds "]L Last change: #{args[2]}"
      ds "]D #{MANUAL_SECTION_NAMES[args[1]]}"
      ds "]W #{args[3]}" if args[3] and !args[3].empty?
      ds "]D #{args[4]}" if args[4] and !args[4].empty?

      heading = "#{args[0]}\\|(\\|#{args[1]}\\|)\\0\\0\\(em\\0\\0\\*(]D"
      @named_strings[:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @named_strings[']L'].empty?

      super(*args, heading: heading)
    end

    define_method 'TX' do |*args|
      ds "Tx #{MANUAL_NAMES[args[0]]}"
      parse "\\fI\\*(Tx\\f1#{args[1]}"
    end

  end
end
