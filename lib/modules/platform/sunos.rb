# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/10/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# SunOS Platform Overrides
#
# TODO
# √ font 'L' is used; /usr/lib/font/fontlist has it as "geneva light"
#    - separate from G ("geneva regular") so: helvetica light

class SunOS
  class Nroff < ::Nroff ; end
  class Troff < ::Troff

    alias :LP :P

    def initialize(source)
      @manual_entry ||= source.file.sub(/\.(\d\S{0,2})$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      super(source)
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          #'Tm' => '&trade;',
          footer: "\\*(]W"
        }
      )
    end

    def init_tr
      super
      @character_translations['*'] = "\e(**"
    end

    def init_TH
      #super
      @register['IN'] = Troff::Register.new(@state[:base_indent])
    end

    # .so with absolute path, headers in /usr/include
    def so(name, breaking: nil)
      osdir = @source_dir.dup
      @source_dir << '/../..' if name.start_with?('/')
      super(name, breaking: breaking)
      @source_dir = osdir
    end

    # index info - what even makes sense to do with this
    # probably nothing, as it seems to be for bound manuals (absolute page number)
    define_method 'IX' do |*_args| ; end

    # some pages call this, but the def is commented out all the way back to 0.3
    # defining it as a no-op suppresses the warning.
    define_method 'UC' do |*_args| ; end

    # good news - margin characters don't seem to be used anywhere in the Sun manual
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
