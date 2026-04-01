# /usr/lib/macros/sml => sml.rb
#
# .\" $Header: /vob/dce.doc/src/doc/macros/sml,v /main/1 1995/04/04 17:43 UTC arh Exp $
#
# very simple translation of HP sml macro package to ruby, in order to avoid
# the various painful overheads of define_method
#
# frozen_string_literal: false
#

class HPUX
  module SML

    def self.extended(k)
      # multiple-inclusion guard
      #return if k.instance_variable_get(:@register)['!s'].value == 1
      #k.send :nr, '!s 1'
      k.send :nr, 'Nn 0 1'
    end

    def aE(*_args) ; end
    def aS(*_args) ; end
    def cE(*_args) ; end
    def cS(*_args) ; ig 'cE' ; end
    def lE(*_args) ; end
    def lS(*_args) ; end

    # draft mode "changed regions" markings macros .zA and .zZ omitted

    def oS(*args)
      send :SP
      ps '-1'
      ft "#{@register['!)']}"
      nf
      nr __unesc_w("!x 8*\\w'0'")
      ts = @register['!x'].value
      ta "#{ts}u +#{ts}u +#{ts}u +#{ts}u +#{ts}u +#{ts}u +#{ts}u +#{ts}u +#{ts}u +#{ts}u"
      send :in, '0' unless args.empty?
    end

    def oE(*_args)
      ps '+1'
      ft 'R'
      fi
      send :P
    end

    def iS(*_args)
      send :SP
      ps '-1'
      ft 'B'
      nf
    end

    def iE(*_args)
      ps '+1'
      ft 'R'
      fi
      send :SP
    end

    def nS(*args)
      send :P
      nr 'Nn +1'
      case "#{args[0]}"
      when 'warning' then ds 'yy Warning:\ \ '
      when 'caution' then ds 'yy Caution:\ \ '
      when 'note'    then ds 'yy Note:\ \ '
      when 'reviewnote'
        ds 'yy'
        ps '+2'
        ft 'B'
        send :P
        parse 'Review Note To Developers:'
        send :P
        ft
        ps '-2'
    else ds "yy #{args[0]}:\ \ "
    end
    ft 'B'
    ll __unesc_w("-\w\007#{@named_strings['yy']}\007u")
    send :in, __unesc_w("+\w\007#{@named_strings['yy']}\007u")
    ti __unesc_w("-\w\007#{@named_strings['yy']}\007u")
    parse "#{@register['yy']}\\c"
    ft
  end

  def nE(*_args)
      nr 'Nn -1'
      send :in, __unesc_w("-\w\007#{@named_strings['yy']}\007u")
      ll __unesc_w("+\w\007#{@named_strings['yy']}\007u")
    end

    def sS(*_args)
      sp '1'
      nr '!x 1'
    end

    def sE(*_args)
      nr '!x 0'
    end

    def fS(*args)
      br
      parse "\\&\\fB#{args[0]}\\fR("
      nr '!+ 1'
      nr '!% 0'
    end

    def fE(*_args)
      parse ');'
      br
      send(:in, '-5i') if @register['!%'] == 1
      nr '!+ 0'
      nr '!% 0'
    end

    def dS(*args)
      if @register['!+'] == 1
        @register['!%'] == 0 ? send(:in, '+.5i') : parse(',')
      end
      br
      parse "\\&\\fB#{args[0]}\\fR"
      nr '!% 1'
    end

    def dE(*_args)
      parse ';' if @register['!+'] == 0
    end

    def kY(*args)
      parse "\\&\\fB<#{args[0]}>\\fR"
    end

    define_method 'K,' do |*args|
      parse "\\&\\fB<#{args[0]}>\\fR#{args[2]}"
    end

    define_method ',K' do |*args|
      parse "\\&#{args[0]}\\fB<#{args[1]}>\\fR"
    end

    def eM(*args)
      parse "\\&\\fI#{args[0]}\\fR"
    end

    define_method 'E,' do |*args|
      parse "\\&\\fI#{args[0]}\\fR\\|#{args[1]}"
    end

    define_method ',E' do |*args|
      parse "\\&\\fR#{args[0]}\\|\\fI#{args[1]}\\fR"
    end

    def dI(*args)
      so args[0]
    end

    def eI(*args)
      nf
      eo
      c2 "\006"
      cc "\007"
      so args[0]
      cc
      c2
      ec
      fi
    end

    def pI(*args)
      warn ".pI : including .eps file #{args[0]} ?!"
      br
      ne args[1]
      send :P!, args[0], args[1]
      sp args[1]
    end
  end
end
