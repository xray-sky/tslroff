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
#   C headers - /usr/include
#

module NBI_4_2BSD
  class Troff < Troff::Man
    alias :LP :P

    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.(\d\S?)$/, '')
      @manual_section ||= Regexp.last_match[1]
      @output_directory ||= "man#{@manual_section}"
      #@state[:footer] = "\\*(]D\\0\\0\\(em\\0\\0\\*(]W"
      super(source, **kwargs)
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          # tmac.an.new
          footer: String.new('\\*(]W'),
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

  def self.name_for_section(sec)
    case sec.downcase
    when '1'    then "<strong>#{sec}.</strong> Commands"
    when '1c'   then "<strong>#{sec}.</strong> Communications Commands"
    when '1g'   then "<strong>#{sec}.</strong> Graphics Commands"
    when '2'    then "<strong>#{sec}.</strong> System Calls"
    when '3'    then "<strong>#{sec}.</strong> Subroutines and Libraries"
    when '3c'   then "<strong>#{sec}.</strong> Compatibility Routines"
    when '3f'   then "<strong>#{sec}.</strong> FORTRAN Library"
    when '3m'   then "<strong>#{sec}.</strong> Math Library"
    when '3n'   then "<strong>#{sec}.</strong> Network Support Library"
    when '3s'   then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3x'   then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '4'    then "<strong>#{sec}.</strong> Special Files"
    when '4f'   then "<strong>#{sec}.</strong> Network Protocol Families"
    when '4i'   then "<strong>#{sec}.</strong> Integrated Solutions Specific Devices"
    when '4n'   then "<strong>#{sec}.</strong> Network Facilities"
    when '4p'   then "<strong>#{sec}.</strong> Network Protocols"
    when '5'    then "<strong>#{sec}.</strong> File Formats"
    when '6'    then "<strong>#{sec}.</strong> Games"
    when '7'    then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '8'    then "<strong>#{sec}.</strong> Maintenance Commands"
    else "Section #{sec}"
    end
  end
end
