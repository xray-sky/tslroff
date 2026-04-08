# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/05/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# ISI/NBI 4.2BSD Platform Overrides (tmac.an.new)
#
# TODO
#   garbage from extraction in a bunch of the manuals
#

module NBI_4_2BSD
  class Troff < Troff
    alias :LP :P

    def initialize(source)
      @manual_entry ||= source.file.sub(/\.(\d\S?)$/, '')
      @manual_section ||= Regexp.last_match[1]
      @output_directory ||= "man#{@manual_section}"
      #@state[:footer] = "\\*(]D\\0\\0\\(em\\0\\0\\*(]W"
      super(source)
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          # tmac.an.new
          footer: "\\*(]W".+@,
          ']D' => 'Unix Programmer\'s Manual', # default set by .TH
          ']W' => '\\f3INTEGRATED SOLUTIONS 4.2 BSD\\f1' # set by .}F
        }
      )
    end

    def init_tr
      super
      @character_translations['*'] = "\e(**"
    end

    def TH(*args)
      ds "]L #{args[2]}"
      #ds "]W #{args[3]}" # set in .TH but always overridden by .}F
      ds "]D #{args[4]}" if args[4] and !args[4].empty?

      heading = "#{args[0]}\\|(\\|#{args[1]}\\|)\\0\\0\\(em\\0\\0\\*(]D"
      @named_strings[:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @named_strings[']L'].empty?

      super(*args, heading: heading)
    end

    # tmac.an.new
    def UC(*args)
      ds(']W ' + case args[0]
                 when '', nil then '3rd Berkeley Distribution'
                 when '4' then '4th Berkeley Distribution'
                 else "#{args[1]} #{args[0]} BSD"
                 end
        )
    end

    def VE(*_args)
      warn ".VE can't yet draw margin characters (.mc)"
    end

    def VS(*_args)
      warn ".VS can't yet draw margin characters (.mc)"
    end

  end
end
