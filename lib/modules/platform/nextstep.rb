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
#

class NEXTSTEP
  class Troff < ::Troff

    alias :LP :P

    def initialize(source)
      @manual_entry ||= source.file.sub(/\.(\d\S*)$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      super(source)
    end

    def init_ds
      super
      @state[:named_string].merge!(
        {
          #'Tm' => '&trade;',
          ']D' => 'UNIX Programmer\'s Manual',
          ']W' => '7th Edition',
          footer: "\\*(]W"
        }
      )
    end

    def init_tr
      super
      @state[:translate]['*'] = "\e(**"
    end

    def init_TH
      #super
      @register['IN'] = Troff::Register.new(@state[:base_indent])
    end

    define_method 'AT' do |*args|
      ds ']W ' + case args[0]
                 when '3' then '7th Edition'
                 when '4' then 'System III'
                 when '5' then "System V#{" Release #{args[1]}"} if args[1] and !args[1].empty?}"
                 else '7th Edition'
                 end
    end

    define_method 'DE' do |*_args|
      send 'RE'
      fi
      sp '.5'
    end

    define_method 'DS' do |*_args|
      send 'RS'
      nf
      sp
    end

    define_method 'TH' do |*args|
      ds "]L #{args[2]}"
      ds "]W #{args[3]}" if args[3] and !args[3].strip.empty?
      ds "]D #{args[4]}" if args[4] and !args[4].strip.empty?

      @state[:named_string][:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @state[:named_string][']L'].empty?
      heading = "#{args[0]}\\|(\\|#{args[1]}\\|)"
      heading << '\\0\\0\\(em\\0\\0\\*(]D'

      super(*args, heading: heading)
    end

    define_method 'UC' do |*args|
      ds ']W ' + case args[0]
                 when '3' then '3rd Berkeley Distribution'
                 when '4' then '4th Berkeley Distribution'
                 when '5' then '4.2 Berkeley Distribution'
                 when '6' then '4.3 Berkeley Distribution'
                 else '3rd Berkeley Distribution'
                 end
    end

    define_method 'VE' do |*args|
      # .if '\\$1'4' .mc \s12\(br\s0
      # draws a 12pt box rule as right margin character
      warn "can't yet .VE #{args.inspect}"
    end

    define_method 'VS' do |*args|
      # .mc
      # clears box rule margin character
      warn "can't yet .VS #{args.inspect}"
    end

  end
end

class OPENSTEP < ::NEXTSTEP ; end
