# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/04/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# BSD Platform Overrides (tmac.an.new)
#
# TODO
#

class BSD
  class Troff < Troff

    alias :LP :P

    def initialize(source)
      @manual_entry ||= source.file.sub(/\.(?:\d\S?)$/, '')
      # assigning @manual_section here defeats parse_title and means we get the filename's section for output_dir only
      #@manual_section ||= Regexp.last_match[1]
      #@output_directory ||= "man#{@manual_section}"
      #@state[:footer] ||= "\\*(]D\\0\\0\\(em\\0\\0\\*(]W"
      case source.file
      when /Makefile/
        raise ManualIsBlacklisted, 'is makefile'
      end
      super(source)
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          footer: "\\*(]W",
          # tmac.an.new
          ']D' => 'Unix Programmer\'s Manual', # default set by .TH
          ']W' => '7th Edition' # default set by .TH
        }
      )
    end

    def init_tr
      super
      @character_translations['*'] = "\e(**"
    end

    # .so with absolute path, headers in /usr/include
    def so(name, breaking: nil, basedir: nil)
      basedir = "#{@source.dir}#{"/.." if name.start_with?('/')}"
      super(name, breaking: breaking, basedir: basedir)
    end

    # tmac.an.new
    def AT(*args)
      ds(']W ' + case args[0]
                 when '4' then 'System III'
                 when '5' then "System V#{" Release #{args[1]}" if !args[1]&.empty?}"
                 else '7th Edition'
                 end
        )
    end

    def DE(*_args)
      fi
      send 'RE'
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

      heading = "#{args[0]}\\^(\\^#{args[1]}\\^)\\0\\0\\(em\\0\\0\\*(]D"
      @named_strings[:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @named_strings[']L'].empty?

      super(*args, heading: heading)
    end

    # tmac.an.new
    #def UC(v = nil, *_args)
    #  ds(']W ' + case v
    #             when '4' then '4th Berkeley Distribution'
    #             when '5' then '4.2 Berkeley Distribution'
    #             when '6' then '4.3 Berkeley Distribution'
    #             else '3rd Berkeley Distribution'
    #             end
    #    )
    #end

    def VE(*_args)
      warn ".VE can't yet draw margin characters (.mc)"
    end

    def VS(*_args)
      warn ".VS can't yet draw margin characters (.mc)"
    end

  end
end
