# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/14/23.
# Copyright 2023 Typewritten Software. All rights reserved.
#
#
# DYNIX Platform Overrides (tmac.an.new)
#
# TODO
#

module DYNIX_ptx
  class Manual < Manual
    def initialize(source, **kwargs)
      case File.basename source
      when 'Makefile' then raise ManualIsBlacklisted, 'not a manual entry'
      end
      super(source, **kwargs)
    end
  end

  class Nroff < Nroff
    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.(\d\S?)$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      super(source, **kwargs)
    end
  end

  class Troff < Troff::Man
    alias :LP :P

    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.(\d\S?)$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      super(source, **kwargs)
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          # tmac.an.new
          footer: "\\*(]W".+@,
          ']D' => "UNIX Programmer's Manual", # default set by .TH
          ']W' => '7th Edition', # default set by .TH
          'V)' => ''
        }
      )
    end

    def init_tr
      super
      @character_translations['*'] = "\e(**"
    end

    def TH(*args)
      rm '}C' if @named_strings['V)'].empty?
      nr 'IN .5i'
      ds "]H #{args[0]}\\^(\\^#{args[1]}\\^)"
      ds "]L #{args[2]}"
      ds "]W Revision #{args[2]}"
      ds "]W #{args[3]}" if args[3] and !args[3].strip.empty?
      ds "]D Dynix Programmer's Manual" unless @named_strings['V)'].empty?
      ds "]D #{args[4]}" if args[4] and !args[4].strip.empty?

      heading = "\\*(]H\\0\\0\\(em\\0\\0\\*(]D"
      @named_strings[:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @named_strings[']L'].empty?

      super(*args, heading: heading)
    end

    # tmac.an.new
    def UC(v = '', *args)
      ds(']W ' + case v
                 when ''  then '3rd Berkeley Distribution'
                 when '4' then '4th Berkeley Distribution'
                 else "#{args[1]} #{args[0]} BSD".tap { |m| warn "REVIEW .UC #{v.inspect} / #{args.inspect}" } # REVIEW #{args[0]} #{v} BSD ??
                 end
            )
    end

    def VE(*_args)
      warn ".VE can't yet draw margin characters (.mc)"
    end

    def VS(*_args)
      warn ".VS can't yet draw margin characters (.mc)"
    end

    def Ps(*args)
      warn "REVIEW .Ps #{args.inspect}"
      ft '5'
      sp
      nf
      send :in, '+0.5i'
    end

    def Pe(*args)
      warn "REVIEW .Pe #{args.inspect}"
      sp
      fi
      send :in, '-0.5i'
      ft 'P'
    end

  end

  def self.name_for_section(sec)
    case sec.downcase
    when '1'  then "<strong>#{sec}.</strong> Commands"
    when '1c' then "<strong>#{sec}.</strong> Communications Commands"
    when '1g' then "<strong>#{sec}.</strong> Graphics Commands"
    when '2'  then "<strong>#{sec}.</strong> System Calls"
    when '3'  then "<strong>#{sec}.</strong> C Library"
    when '3c' then "<strong>#{sec}.</strong> Compatibility Library Functions"
    when '3m' then "<strong>#{sec}.</strong> Math Library"
    when '3n' then "<strong>#{sec}.</strong> Network Support Library"
    when '3p' then "<strong>#{sec}.</strong> DYNIX Parallel Programming Library"
    when '3r' then "<strong>#{sec}.</strong> RPC Library"
    when '3s' then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3x' then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '4'  then "<strong>#{sec}.</strong> Special Files and Hardware Support"
    when '4f' then "<strong>#{sec}.</strong> Network Protocol Families"
    when '4n' then "<strong>#{sec}.</strong> Network Facilities"
    when '4p' then "<strong>#{sec}.</strong> Network Protocols"
    when '5'  then "<strong>#{sec}.</strong> File Formats"
    when '7'  then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '8'  then "<strong>#{sec}.</strong> Maintenance Commands"
    when '8c' then "<strong>#{sec}.</strong> Network Services"
    when '8s' then "<strong>#{sec}.</strong> Standalone Utilities"
    else "Section #{sec}"
    end
  end
end
