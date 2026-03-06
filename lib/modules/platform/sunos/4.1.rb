# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/10/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# SunOS 4.1.4 Platform Overrides
#
# tmac.an defines \n(PN as the current page number and messes with it in }F
#
# TODO
#   olit widget set pages are crazy with macros, and give according output
#    - e.g. AbbrevMenuButton(3w)
#    - also probably these should end up in man3w (based on .TH), instead of man3 (based on filename)
#   xview.7 -- wants LB font (geneva light bold, presumably, but referred to as "Listing Font")
#

class SunOS::V4_1

  class Nroff < ::SunOS::Nroff

    def initialize(source)
      super(source)
      @lines_per_page = nil
    end

    def source_init
      case @source.file
      when 'ce_db_build.1', 'ce_db_merge.1' # no title line
        define_singleton_method(:get_title) { { section: '1' } }
        # TODO also has see also link w/ whitespace (e.g. "ref (section)")
      end
      super
    end

  end

  class Troff < ::SunOS::Troff

    MANUAL_NAMES = {
      'GSBG'     => 'Getting Started ',
      'SUBG'     => 'Customizing SunOS',
      'SHBG'     => 'Basic Troubleshooting',
      'SVBG'     => 'SunView User\'s Guide',
      'MMBG'     => 'Mail and Messages',
      'DMBG'     => 'Doing More with SunOS',
      'UNBG'     => 'Using the Network',
      'GDBG'     => 'Games, Demos & Other Pursuits',
      'CHANGE'   => 'SunOS 4.1 Release Manual',
      'INSTALL'  => 'Installing SunOS 4.1',
      'ADMIN'    => 'System and Network Administration',
      'SECUR'    => 'Security Features Guide',
      'PROM'     => 'PROM User\'s Manual',
      'DIAG'     => 'Sun System Diagnostics',
      'SUNDIAG'  => 'Sundiag User\'s Guide',
      'MANPAGES' => 'SunOS Reference Manual',
      'REFMAN'   => 'SunOS Reference Manual',
      'SSI'      => 'Sun System Introduction',
      'SSO'      => 'System Services Overview',
      'TEXT'     => 'Editing Text Files',
      'DOCS'     => 'Formatting Documents',
      'TROFF'    => 'Using \\&\\fBnroff\\fP and \\&\\fBtroff\\fP',
      'INDEX'    => 'Global Index',
      'CPG'      => 'C Programmer\'s Guide',
      'CREF'     => 'C Reference Manual',
      'ASSY'     => 'Assembly Language Reference',
      'PUL'      => 'Programming Utilities and Libraries',
      'DEBUG'    => 'Debugging Tools',
      'NETP'     => 'Network Programming',
      'DRIVER'   => 'Writing Device Drivers',
      'STREAMS'  => 'STREAMS Programming',
      'SBDK'     => 'SBus Developer\'s Kit',
      'WDDS'     => 'Writing Device Drivers for the SBus',
      'FPOINT'   => 'Floating-Point Programmer\'s Guide',
      'SVPG'     => 'SunView\\ 1 Programmer\'s Guide',
      'SVSPG'    => 'SunView\\ 1 System Programmer\'s Guide',
      'PIXRCT'   => 'Pixrect Reference Manual',
      'CGI'      => 'SunCGI Reference Manual',
      'CORE'     => 'SunCore Reference Manual',
      '4ASSY'    => 'Sun-4 Assembly Language Reference',
      'SARCH'    => '\\s-1SPARC\\s0 Architecture Manual',
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

    def source_init
      case @source.file
      when 'default.1' then @manual_entry = '_default'
      when 'index.3'   then @manual_entry = '_index'
      end
    end

    def init_ds
      super
      @state[:named_string].merge!(
        {
          ']W' => 'Sun Release 4.1'
        }
      )
    end

    define_method 'SB' do |*args|
      parse "\\&\\fB\\s-1\\&#{args[0..5].join(' ')}\\s0\\fR"
    end

    define_method 'TH' do |*args|
      heading = "#{args[0]}\\|(\\|#{args[1]}\\|)\\0\\0\\(em\\0\\0\\*(]D"
      req_ds "]L Last change: #{args[2]}"
      req_ds "]D #{MANUAL_SECTION_NAMES[args[1]]}"
      req_ds "]W #{args[3]}" if args[3] and !args[3].empty?
      req_ds "]D #{args[4]}" if args[4] and !args[4].empty?

      req_ds "]L Last change: #{args[2]}"
      @state[:named_string][:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @state[:named_string][']L'].empty?

      super(*args, heading: heading)
    end

    define_method 'TX' do |*args|
      ds "Tx #{MANUAL_NAMES[args[0]]}"
      parse "\\fI\\*(Tx\\f1#{args[1]}"
    end

  end
end

# all literally identical

class SunOS::V4_1_1 < SunOS::V4_1 ; end
class SunOS::V4_1_2 < SunOS::V4_1 ; end
class SunOS::V4_1_3 < SunOS::V4_1 ; end
class SunOS::V4_1_3B < SunOS::V4_1 ; end
class SunOS::V4_1_3_U1 < SunOS::V4_1 ; end
class SunOS::V4_1_4 < SunOS::V4_1 ; end
