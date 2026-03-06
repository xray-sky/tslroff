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

class DYNIX_ptx
  class Nroff < ::Nroff

    def initialize(source)
      @manual_entry ||= source.file.sub(/\.(\d\S?)$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      super(source)
    end

    def source_init
      case @source.file
      when 'Makefile' then raise ManualIsBlacklisted, 'not a manual entry'
      end
      super
      @output_directory = "man#{@manual_section}"
    end

  end

  class Troff < ::Troff

    alias :LP :P

    def initialize(source)
      @manual_entry ||= source.file.sub(/\.(\d\S?)$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      super(source)
    end

    def source_init
      case @source.file
      when 'Makefile' then raise ManualIsBlacklisted, 'not a manual entry'
      end
      super
      @output_directory = "man#{@manual_section}"
    end

    def init_ds
      super
      @state[:named_string].merge!(
        {
          # tmac.an.new
          footer: "\\*(]W",
          ']D' => "UNIX Programmer's Manual", # default set by .TH
          ']W' => '7th Edition', # default set by .TH
          #']W' => File.mtime(@source.filename).strftime("%B %d, %Y"),
          'V)' => ''
        }
      )
    end

    def init_tr
      super
      @state[:translate]['*'] = "\e(**"
    end

    # .so with absolute path, headers in /usr/include
    #def so(name, breaking: nil)
    #  osdir = @source_dir.dup
    #  @source_dir << '/..'
    #  super(name, breaking: breaking)
    #  @source_dir = osdir
    #end

    define_method 'TH' do |*args|
      rm '}C' if @state[:named_string]['V)'].empty?
      nr 'IN .5i'
      ds "]H #{args[0]}\\^(\\^#{args[1]}\\^)"
      ds "]L #{args[2]}"
      ds "]W Revision #{args[2]}"
      ds "]W #{args[3]}" if args[3] and !args[3].strip.empty?
      ds "]D Dynix Programmer's Manual" unless @state[:named_string]['V)'].empty?
      ds "]D #{args[4]}" if args[4] and !args[4].strip.empty?

      heading = "\\*(]H\\0\\0\\(em\\0\\0\\*(]D"
      @state[:named_string][:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @state[:named_string][']L'].empty?

      super(*args, heading: heading)
    end

    # tmac.an.new
    define_method 'UC' do |v = '', *args|
      ds(']W ' + case v
                 when ''  then '3rd Berkeley Distribution'
                 when '4' then '4th Berkeley Distribution'
                 else "#{args[1]} #{args[0]} BSD".tap { |m| warn "REVIEW .UC #{v.inspect} / #{args.inspect}" } # REVIEW #{args[0]} #{v} BSD ??
                 end
            )
    end

    define_method 'VE' do |*_args|
      warn ".VE can't yet draw margin characters (.mc)"
    end

    define_method 'VS' do |*_args|
      warn ".VS can't yet draw margin characters (.mc)"
    end

    define_method 'Ps' do |*args|
      warn "REVIEW .Ps #{args.inspect}"
      ft '5'
      sp
      nf
      send :in, '+0.5i'
    end

    define_method 'Pe' do |*args|
      warn "REVIEW .Pe #{args.inspect}"
      sp
      fi
      send :in, '-0.5i'
      ft 'P'
    end

  end
end
