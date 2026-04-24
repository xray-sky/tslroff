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
    def initialize file, vendor_class: nil, source_args: {}
      case File.basename file
      when 'Makefile' then raise ManualIsBlacklisted, 'not a manual entry'
      end
      super file, vendor_class: vendor_class, source_args: source_args
    end
  end

  class Nroff < Nroff
    def initialize(source)
      @manual_entry ||= source.file.sub(/\.(\d\S?)$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      super(source)
    end
  end

  class Troff < Troff::Man
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
end
