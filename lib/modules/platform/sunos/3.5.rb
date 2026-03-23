# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/08/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# SunOS 3.5 Platform Overrides
#

class SunOS::V3_5

  class Manual < ::Manual
    def initialize(file, vendor_class: nil, source_args: {})
      case File.basename(file)
      when 'mc68881version.8' then @source = Source.new(file, magic: 'Troff', source_args: source_args)
      end
      super(file, vendor_class: vendor_class, source_args: source_args)
    end
  end

  class Troff < ::SunOS::Troff

    MANUAL_SECTION_NAMES = {
      '1'  => 'USER COMMANDS',
      '1C' => 'USER COMMANDS',
      '1G' => 'USER COMMANDS',
      '1S' => 'SUN-SPECIFIC USER COMMANDS',
      '1V' => 'USER COMMANDS',
      '2'  => 'SYSTEM CALLS',
      '2V' => 'SYSTEM CALLS',
      '3'  => 'C LIBRARY FUNCTIONS',
      '3C' => 'COMPATIBILITY ROUTINES',
      '3F' => 'FORTRAN LIBRARY ROUTINES',
      '3M' => 'MATHEMATICAL FUNCTIONS',
      '3N' => 'NETWORK FUNCTIONS',
      '3R' => 'RPC SERVICES',
      '3S' => 'STANDARD I/O LIBRARY',
      '3X' => 'MISCELLANEOUS FUNCTIONS',
      '4'  => 'SPECIAL FILES',
      '4F' => 'SPECIAL FILES',
      '4I' => 'SPECIAL FILES',
      '4N' => 'SPECIAL FILES',
      '4P' => 'SPECIAL FILES',
      '4S' => 'SPECIAL FILES',
      '4V' => 'SPECIAL FILES',
      '5'  => 'FILE FORMATS',
      '5V' => 'FILE FORMATS',
      '6'  => 'GAMES AND DEMOS',
      '7'  => 'TABLES',
      '8'  => 'MAINTENANCE COMMANDS',
      '8C' => 'MAINTENANCE COMMANDS',
      '8S' => 'MAINTENANCE COMMANDS'
    }

    MANUAL_SECTION_NAMES.default = 'UNKNOWN SECTION OF THE MANUAL'

    def initialize(source)
      case source.file
      when 'list', 'Makefile', 'rfiles', 'ufiles', 'vfiles'
        raise ManualIsBlacklisted, 'not a manual entry'
      when 'eqn.eqn', 'eqnchar.eqn'
        raise ManualIsBlacklisted, 'eqn preprocessed entries'
      end
      super(source)
    end

    def source_init
      case @source.file
      when 'default.1' then @manual_entry = '_default'
      when 'erf.3m'
        # troff switches font size to do the baseline shift, and I can't get that in html.
        # the ouput shift is in em, at the (smaller) size of the outputted text.
        @source.patch_line(31, /\\s10/, '\s12', global: true)
        @source.patch_line(31, /(\\u)/, '\\v@-0.5v@', global: true)
        @source.patch_line(31, /(\\d)/, '\\v@0.5v@', global: true)
      when 'lgamma.3m' # REVIEW gamma.3m? (doesn't exist, so isn't a problem?)
        # troff switches font size to do the baseline shift, and I can't get that in html.
        # the ouput shift is in em, at the (smaller) size of the outputted text.
        @source.patch_line(27, /\\s10/, '\s12', global: true)
        @source.patch_line(27, /(\\u)/, '\\v@-0.5v@', global: true)
        @source.patch_line(27, /(\\d)/, '\\v@0.5v@', global: true)
      end
      super
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          ']W' => 'Sun Release 3.5'
        }
      )
    end

    # REVIEW
    # this is used seemingly to prevent processing the next line
    # as a request. but, it's not in tmac.an or the DWB manual.
    # still used in 3.5, but only for binmail(1)
    def li(*_args)
      parse("\\&" + next_line)
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

  end
end
