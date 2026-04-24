# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/10/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Plan9 Platform Overrides
#
# TODO
#   .fp 1 R LucidaSans
#   .fp 2 I LucidaSansI
#   .fp 3 B LucidaSansB
#   .fp 5 L LucidaCW
#   ...maybe see about making those actually use Lucida
#
#   grap(1) actually includes examples. is it reasonable to add support for this?
#   pic(1) as well!
#

module Plan9

  # name collision with "Geneva Light"
  #class Font::L < ::Font::C ; end  ### TypeError: superclass mismatch for class L
  class Font::L < Font
    def css_style ; %(font-family:'CMU Typewriter',monospace;) ; end
  end

  class Troff < Troff::Man
    alias :LP :P

    def initialize(source)
      case source.file
      when 'INDEX', 'INDEX.html' # REVIEW have a look at the INDEX.html - minimum viable for us probably
        raise ManualIsBlacklisted, 'is nonsense'
      end
      super(source)
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          'Tm' => '&trade;',
          ']D' => 'Plan 9',
          ']W' => File.mtime(@source.path).strftime("%B %d, %Y"),
          footer: "\\*(]D\\0\\0\\(em\\0\\0\\*(]W".+@
        }
      )
    end

    def init_fp
      super
      mount_font 5, 'L'
    end

    def init_tr
      super
      @character_translations['*'] = "\e(**"
    end

    def init_PD
      super
      @register['PD'] = @register[')P'] # Plan9 .PD sets \n(PD instead of \n()P - unknown if it is made use of
    end

    def init_TH
      #super
      @register['IN'] = Troff::Register.new(@base_indent)
    end

    # TODO convert from define_method to def
    %w[B I L].each do |a|
      define_method a do |*args|
        fp = @mounted_fonts.index (a=='B') ? 'L' : a # .B and .L both use \f5
        nh
        #it('1', '}N')
        it '1 }f'
        if args.any?
          parse "\\%\\&\\f#{fp}#{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]}"
        else
          ft fp.to_s
        end
        send 'HY'
      end
    end

    %w[RI IR IB RB BR BI LR RL].each do |m|
      define_method m do |*args|
        (a,b) = m.scan(/./)
        fpa = @mounted_fonts.index (a=='B') ? 'L' : a # .B and .L both use \f5
        fpb = @mounted_fonts.index (b=='B') ? 'L' : b # .B and .L both use \f5
        nh
        parse %(.}S #{fpa} #{fpb} \\& "#{args[0]}" "#{args[1]}" "#{args[2]}" "#{args[3]}" "#{args[4]}" "#{args[5]}")
        send 'HY'
      end
    end

    # there's a pile of macros defined for doing two column text, which
    # seems like an arsepain for html. fortunately it doesn't look like any
    # are used in the online manual?
    # .2C, .1C, .C1, .C2, .C3
    # no proprietary markings (.PM, .)G) either, apparently

    def EE(*_args)
      ft '1'
      fi
    end

    def EX(*_args)
      ft '5'
      nf
    end

    def HY(*_args)
      hy '14'
    end

    def TF(*args)
      parse %(.IP "" "\\w'\f5#{args[0]}\\ \\ \\fP'u")
      send 'PD', '0'
    end

    def TH(*args)
      #ds "]L (\\^#{args[2]}\\^)" if args[2] and !args[2].strip.empty?
      ds "]L #{args[2]}" # I choose not to take tmac.an's parens
      ds "]D #{args[3]}" if args[3] and !args[3].strip.empty?

      heading = "#{args[0]}\\|(\\|#{args[1]}\\|)".+@
      heading << '\\0\\0\\(em\\0\\0\\*(]L' unless @named_strings[']L'].empty?

      super(*args, heading: heading)
    end

  end
end
