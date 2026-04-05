# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Motorola SysV Platform Overrides
#
# Defines .TX but with all SunOS titles. Leave it out.
# Uses \f4 like CX-UX 6.20. Probably related.
#
# TODO pic - allocb(3d), dupb(3d), linkb(3d)
# TODO
#   options to TH happening oddly - no arg[1] for section??
#   a few pages want to .rm }C for some reason
#

module Motorola_SysV
  class Nroff < Nroff ; end

  # looks like none of this matters much, as the provided pages are all nroff format except for X11.
  class Troff < Troff

    alias :LP :P

    def initialize(source)
      @manual_entry ||= source.file.sub(/\.(\d\S?)$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      super(source)
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          footer: "\\*(]W".+@,
          #'Tm' => '&trade;',
          # DocString_MOT
          'sS' => 'UNIX',
          'sl' => 'UNIX SYSTEM V/68 or V/88 Release 4',
          'sL' => 'UNIX SYSTEM V/68 or V/88 Release 4',
          's3' => 'UNIX SYSTEM V/68 and V/88 Release 4',
          's4' => 'UNIX SYSTEM V/68 and V/88 Release 4',
          's1' => 'UNIX SYSTEM V/68',
          's2' => 'UNIX SYSTEM V/88',
          'hC' => 'Motorola',
          'hs' => 'M68000 or M88000 family of processors',
          'h1' => 'M68000 family of processors',
          'h2' => 'M68000 family of processors',
          'h4' => 'M68000 family of processors',
          'h3' => 'M88000 family of processors',
          'hl' => 'supported Delta Series and DeltaSERVER platforms',
          'rp' => 'platform',
          # For internal Motorola use only
          'rL' => 'RM01',
          ']W' => ''
        }
      )
    end

    def init_fp
      super
      # REVIEW
      @mounted_fonts[4] = 'BI'
      @mounted_fonts[5] = 'CW'
    end

    def init_tr
      super
      @character_translations['*'] = "\e(**"
    end

    def init_TH
      #super
      @register['IN'] = Troff::Register.new(@base_indent)
    end

    def TH(*args)
      ds "]D #{MANUAL_SECTION_NAMES[args[1]&.strip]}"
      ds "]L #{args[2]}"
      ds "]W #{args[3]}" if args[3] and !args[3].strip.empty?
      ds "]D #{args[4]}" if args[4] and !args[4].strip.empty?

      heading = "#{args[0]}\\|(\\|#{args[1]}\\|)\\0\\0\\(em\\0\\0\\*(]D"
      @named_strings[:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @named_strings[']L'].empty?

      super(*args, heading: heading)
    end

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

  MANUAL_SECTION_NAMES = {
    '1'  => 'USER COMMANDS ',
    '1C' => 'BASIC NETWORKING COMMANDS',
    '1F' => 'FMLI UTILITIES',
    '1G' => 'GOLD UTILITIES',
    '1M' => 'ADMINISTRATOR COMMANDS ',
    '2'  => 'SYSTEM CALLS',
    '3'  => 'LIBRARY FUNCTIONS',
    '3C' => 'C LIBRARY FUNCTIONS',
    '3E' => 'ELF LIBRARY FUNCTIONS',
    '3G' => 'GENERAL LIBRARY FUNCTIONS',
    '3M' => 'MATHEMATICAL LIBRARY',
    '3N' => 'NETWORK FUNCTIONS',
    '3S' => 'STANDARD I/O FUNCTIONS',
    '3X' => 'MISCELLANEOUS LIBRARY FUNCTIONS',
    '4'  => 'FILE FORMATS',
    '5'  => 'PUBLIC FILES, TABLES, AND TROFF MACROS',
    '7'  => 'SPECIAL FILES AND DEVICES',
    'L'  => 'LOCAL COMMANDS'
  }

  MANUAL_SECTION_NAMES.default = 'MISC. REFERENCE MANUAL PAGES'
  MANUAL_SECTION_NAMES.freeze
end
