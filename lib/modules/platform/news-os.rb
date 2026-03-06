# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/12/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# NEWS-os Platform Overrides
#
# TODO
#   several of the MH pages want to use the T, M, and X fonts (what are they)
#

class NEWS_os
  class Troff < ::Troff

    def initialize(source)
      @manual_entry ||= source.file.sub(/\.([\dnop][^.]*)$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      super(source)
    end

    def init_tr
      super
      @state[:translate]['*'] = "\e(**"
    end

    def init_TH
      #super
      @register['IN'] = Troff::Register.new(@state[:base_indent])
    end

    # doesn't matter, ]W not used in header or footer
    define_method 'AT' do |*args|
      ds ']W ' + case args[0]
                 when '3' then '7th Edition'
                 when '4' then 'System III'
                 when '5' then "System V#{" Release #{args[1]}" if args[1] and !args[1].empty?}"
                 else '7th Edition'
                 end
    end

    # index info - what even makes sense to do with this
    # probably nothing, as it seems to be for bound manuals (absolute page number)
    define_method 'iX' do |*_args| ; end
    define_method 'IX' do |*_args| ; end

    define_method 'TH' do |*args|
      ds "]L #{args[2]}"
      ds "]W #{args[3]}" if args[3] and !args[3].strip.empty?
      ds "]D #{args[4]}" if args[4] and !args[4].strip.empty?

      heading = "#{args[0]}\\|(\\|#{args[1]}\\|)"
      heading << '\\0\\0\\(em\\0\\0\\*(]D' unless @state[:named_string][']D'].empty?

      super(*args, heading: heading)
    end

    # doesn't matter, ]W not used in header or footer
    define_method 'UC' do |*args|
      ds ']W ' + case args[0]
                 when '3' then '3rd Berkeley Distribution'
                 when '4' then '4th Berkeley Distribution'
                 when '5' then '4.2 Berkeley Distribution'
                 when '6' then '4.3 Berkeley Distribution'
                 else '3rd Berkeley Distribution'
                 end
    end

    # good news - margin characters don't seem to be used anywhere in the Sony manual
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
