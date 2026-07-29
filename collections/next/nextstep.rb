# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# NEXTSTEP Platform Overrides
#
# TODO
#   db(3) wants to use the F font - what is it? ...appears to be a mistake.
#   hilarious results with tex(1l), apparently related to baseline shift in TeX logo?
#

module NEXTSTEP
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
          ']D' => 'UNIX Programmer\'s Manual',
          ']W' => '7th Edition',
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

    def AT(*args)
      ds ']W ' + case args[0]
                 when '3' then '7th Edition'
                 when '4' then 'System III'
                 when '5' then "System V#{" Release #{args[1]}"} if args[1] and !args[1].empty?}"
                 else '7th Edition'
                 end
    end

    def DE(*_args)
      send 'RE'
      fi
      sp '.5'
    end

    def DS(*_args)
      send 'RS'
      nf
      sp
    end

    def TH(*args)
      ds "]L #{args[2]}"
      ds "]W #{args[3]}" if args[3] and !args[3].strip.empty?
      ds "]D #{args[4]}" if args[4] and !args[4].strip.empty?

      @named_strings[:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @named_strings[']L'].empty?
      heading = "#{args[0]}\\|(\\|#{args[1]}\\|)\\0\\0\\(em\\0\\0\\*(]D"

      super(*args, heading: heading)
    end

    def UC(*args)
      ds ']W ' + case args[0]
                 when '3' then '3rd Berkeley Distribution'
                 when '4' then '4th Berkeley Distribution'
                 when '5' then '4.2 Berkeley Distribution'
                 when '6' then '4.3 Berkeley Distribution'
                 else '3rd Berkeley Distribution'
                 end
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

  def self.name_for_section(sec)
    case sec.downcase
    when '1'  then "<strong>#{sec}.</strong> Commands"
    when '1c' then "<strong>#{sec}.</strong> Communications Commands"
    when '1g' then "<strong>#{sec}.</strong> Graphics Commands"
    when '1l' then "<strong>#{sec}.</strong> TeX Commands"
    when '2'  then "<strong>#{sec}.</strong> System Calls"
    when '2p' then "<strong>#{sec}.</strong> POSIX System Calls"
    when '3'  then "<strong>#{sec}.</strong> C Library"
    when '3c' then "<strong>#{sec}.</strong> Compatibility Routines"
    when '3m' then "<strong>#{sec}.</strong> Math Library"
    when '3n' then "<strong>#{sec}.</strong> Network Support Library"
    when '3p' then "<strong>#{sec}.</strong> POSIX Compatibility Routines"
    when '3r' then "<strong>#{sec}.</strong> RPC Library"
    when '3s' then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3x' then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '4'  then "<strong>#{sec}.</strong> Special Files"
    when '4f' then "<strong>#{sec}.</strong> Network Protocol Families"
    when '4n' then "<strong>#{sec}.</strong> Network Facilities"
    when '4p' then "<strong>#{sec}.</strong> Network Protocols"
    when '5'  then "<strong>#{sec}.</strong> File Formats"
    when '6'  then "<strong>#{sec}.</strong> Games and Demos"
    when '7'  then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '8'  then "<strong>#{sec}.</strong> Maintenance Procedures"
    when '8c' then "<strong>#{sec}.</strong> Network Services"
    else "Section #{sec}"
    end
  end
end

# module alias
OPENSTEP = NEXTSTEP
