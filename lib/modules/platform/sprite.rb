# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# UCB Sprite Platform Overrides
#
# TODO
#

class Sprite
  class Troff < Troff

    SPRITE_MANUAL_SECTION_NAMES = {
      'admin'   => 'Administrative Commands',
      'cmds'    => 'User Commands',
      'daemons' => 'Daemons',
      'dev'     => 'Devices',
      'files'   => 'File Formats',
      'lib'     => 'C Library Procedures',
      'tcl'     => 'Tcl Command Language Library'
    }

    UNIX_MANUAL_SECTION_NAMES = {
      '1'  => 'User Commands',
      '1C' => 'User Commands',
      '1L' => 'User Commands',
      '2'  => 'C Library Procedures',
      '3'  => 'C Library Procedures',
      '3C' => 'C Library Procedures',
      '3F' => 'Fortran Library Procedures',
      '3M' => 'Mathematical Library Procedures',
      '3N' => 'C Library Procedures',
      '3R' => 'RPC Services',
      '3S' => 'C Library Procedures',
      '3X' => 'C Library Procedures',
      '4'  => 'Devices',
      '5'  => 'File Formats',
      '6'  => 'Games and Demos',
      '7'  => 'Tables',
      '8'  => 'User Commands'
    }

    SPRITE_MANUAL_SECTION_NAMES.default_proc = proc { |_h, k| "UNKNOWN SECTION (#{k})" }
    UNIX_MANUAL_SECTION_NAMES.default = 'UNKNOWN MANUAL SECTION'

    alias :LP :P

    def initialize source
      @manual_entry ||= source.file.sub(/\.(\d\S*|man)$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      super source
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          #'Tm' => '&trade;',
          ']l' => '/sprite/lib/ditroff/', # for including tmac.sprite
          ']W' => 'Sprite version 1.0',
          footer: "\\*(]W\\0\\0\\(em\\0\\0\\*(]L"
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

    # tmac.sprite
    define_method 'AP' do |*args|
      warn "REVIEW - use of .AP #{args.inspect}"
      if args[3] and !args[3].strip.empty?
        send 'TP', args[3]
      elsif args[1] and !args[1].strip.empty?
        send 'TP', "#{@register[')C']}u"
      else
        send 'TP', '15'
      end
      if args[2] and !args[2].strip.empty?
        ta "#{@register[')A']}u", "#{@register[')B']}u"
        parse "#{args[0]} \\fI#{args[1]}\\fP   (#{args[2]})"
      else
        br
        if args[1] and !args[1].strip.empty?
          parse "#{args[0]} \\fI#{args[1]}\\fP"
        else
          parse "\\fI#{args[0]}\\fP"
        end
      end
      send 'DT'
    end

    # tmac.sprite
    define_method 'AS' do |*args|
      nr ')A 10n'
      nr ")A #{to_u(__unesc_w("\\w'#{args[1]}'u+3n"))}" if args[0] and !args[0].strip.empty?
      nr ")B #{to_u("#{@register[')A'].value}u+15n")}"
      nr ")B #{to_u(__unesc_w("\\w'#{args[1]}'u+#{@register[')A'].value}u+3n"))}" if args[1] and !args[1].strip.empty?
      nr ")C #{to_u(__unesc_w("#{@register[')B'].value}u+\\w'(in/out)'u+2n"))}"
    end

    # tmac.sprite
    # start/end boxed text
    # TODO
    define_method 'BE' do |*args|
      warn "don't know how to .BE #{args.inspect} yet"
    end

    define_method 'BS' do |*args|
      warn "don't know how to .BS #{args.inspect} yet"
    end

    # tmac.sprite
    define_method 'HS' do |*args|
      send 'PD'
      send 'AS'
      send 'TH', *args
      ds "]H #{args[0]}"
      ds "]S #{SPRITE_MANUAL_SECTION_NAMES[args[1]]}"
      ds ']D \\*(]S'
      ds "]L #{File.mtime(@source.path).strftime('%B %d, %Y')}"
      ds "]W #{args[3]}" if args[3] and !args[3].strip.empty?
    end

    # tmac.sprite
    define_method 'LG' do |*args|
      ps "+1"
      if args.any?
        parse args.join(' ')
        send '}f'
      else
        it '1 }f'
      end
    end

    # replaced by .HS
    define_method 'TH' do |*args|
      ds "]H #{args[0]}"
      ds "]D #{UNIX_MANUAL_SECTION_NAMES[args[1]]}"
      ds "]L #{args[2]}"
      ds "]W #{args[3]}" if args[3] and !args[3].strip.empty?

      heading = "\\*(]H\\0\\0\\(em\\0\\0\\*(]D"
      super(*args, heading: heading)
    end

    define_method 'VE' do |*args|
      # draws a 12pt box rule as right margin character
      warn "can't yet .VE #{args.inspect}"
    end

    define_method 'VS' do |*args|
      # clears box rule margin character
      warn "can't yet .VS #{args.inspect}"
    end

  end
end
