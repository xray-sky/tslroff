# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Ultrix Platform Overrides
#
# TODO
#   PL (page length) and SF (save font) registers
#

module Ultrix

  # Triumvirate is essentially Helvetica
  class Font::TR < ::Font::H ; end
  class Font::TB < ::Font::HB ; end
  class Font::TI < ::Font::HI ; end

  class Troff < Troff

    alias :LP :P

    def initialize source
      @manual_entry ||= source.file.sub(/\.([n\d][^.\s]*)$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      @related_info_heading ||= %r{SEE(?: |&nbsp;)+ALSO}i  # 3.x, 4.x
      super source
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          #'Tm' => '&trade;',
          footer: ''.+@ # just a page number
        }
      )
    end

    def init_fp
      super
      # Geneva Light changed to Triumvirate Italic for LN01
      # Geneva Regular changed to Triumvirate Regular for LN01
      @mounted_fonts[4] = 'BI'
      @mounted_fonts[5] = 'CW' # from .CW '.nr SF 5'
      @mounted_fonts[8] = 'HB' # Triumvirate Bold, from .TB '.nr SF 8'
    end

    def init_TH
      #super
      @register['IN'] = Troff::Register.new(@base_indent)
    end

    def CT(*args)
      parse "\\s-2<\\|CTRL\\|#{args[0]}\\|>\\s+2"
    end

    def CW(*_args)
      ft 'CW'
      nr 'SF', '5'
    end

    def EE(*_args)
      fi
      send 'in', '-.5i'
      sp '.5'
      ft '1'
    end

    def EX(*_args)
      nf
      sp '.5'
      send 'in', '+.5i'
      ft 'CW' # Geneva regular (changed to Constant Width for LN01)
    end

    def G(*args)
      ft 'H'
      if args.any?
        parse args.join(' ')
        send '}f'
      else
        it '1 }f'
      end
    end

    def GL(*args)
      ft 'L'
      if args.any?
        parse args.join(' ')
        send '}f'
      else
        it '1 }f'
      end
    end

    def I1(*args)
      warn "REVIEW .I1 #{args.inspect}"
      ti "+\\w'#{args[0]}'u"
    end

    def I2(*args)
      warn "REVIEW .I2 #{args.inspect}"
      sp '-1'
      ti "+\\w'#{args[0]}'u"
    end

    def MS(*args)
      parse "\\f(TR\\|#{args[0]}\\|\\fP\\fR(#{args[2]})\\fP#{args[2]}"
    end

    def NE(*_args)
      ce '0'
      send 'in', '-5n'
      sp '12p'
    end

    def NT(*args)
      ds 'NO NOTE'
      ds "NO #{args[1]}" if args[1] and args[1] != 'C'
      ds "NO #{args[0]}" if args[0] and args[0] != 'C'
      sp '12p'
      send 'TB'
      ce
      parse "\\*(NO" # not unescape - need to trigger input trap
      sp '6p'
      ce '99' if args[0..1].include? 'C'
      send 'in', '+5n'
      # also bring in right margin by the same.
      # it'll work as long as there's only one paragraph worth of note
      @current_block.style.css[:margin_right] = @current_block.style.css[:margin_left]
      send 'R'
    end

    # appears to be for indexing purposes
    def NX(*_args) ; end

    def PN(*args)
      parse "\\f(TR\\|#{args[0]}\\|\\fP#{args[1]}"
    end

    def R(*_args)
      ft '1'
      nr 'SF 1'
    end

    def RN(*_args)
      parse "\\s-2<\\|RETURN\\|>\\s+2"
    end

    def TB(*args)
      warn "REVIEW .TB #{args.inspect}"
      @register['PF'] = @register['.f'].dup
      ft 'HB' # Triumvirate Bold
      if args.any?
        parse args.join(' ')
        send 'R'
      else
        nr 'SF 8'
      end
    end

    def VE(*args)
      # .if '\\$1'4' .mc \s12\(br\s0
      # draws a 12pt box rule as right margin character
      warn "can't yet .VE #{args.inspect}"
    end

    def VS(*args)
      # .mc
      # clears box rule margin character
      warn "can't yet .VS #{args.inspect}"
    end

  end
end
