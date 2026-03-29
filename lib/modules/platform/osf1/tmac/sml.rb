# /usr/share/lib/tmac/sml => sml.rb
#
# .\" @(#)$RCSfile: sml,v $ $Revision: 4.1.2.2 $ (DEC) $Date: 1992/11/23 17:09:53 $
#
# very simple translation of OSF/1 sml macro package to ruby, in order to avoid
# the various painful overheads of define_method - with persisted webdriver width
# cache, is effective at cutting Tru64 processing time by 65%. (~40m -> ~12m)
#
# All DEC OSF/1 / Digital UNIX / Tru64 RSML macros same since 1.0
# except introduction of !r added at or before 3.0
#
# frozen_string_literal: false
#

class OSF1
  module SML

    def self.extended(k)
      k.send :nr, '!s 1'
      k.send :ds, 'L \&\fB'
      k.send :ds, 'V \&\fI'
      k.send :ds, 'A \&\f(CW'
      k.send :ds, 'N \&\f(CW'
      k.send :ds, 'O \&\fR'
      k.send :ds, 'C \&\f(CW'
      k.send :ds, 'U \&\fB'
      k.send :ds, 'E \&\fI'
    end

    def aE(*_args) ; end
    def aS(*_args) ; end
    def cE(*_args) ; end
    def cS(*_args) ; ig 'cE' ; end
    def lE(*_args) ; end
    def lS(*_args) ; end
    def nL(*_args) ; br ; end
    def nP(*_args) ; bp ; end
    def pM(*_args) ; end
    def tH(*_args) ; send :TH ; end
    def wH(*_args) ; end

    def oS(*_args)
      send :P
      ps '-1'
      ft 'CW'
      nf
      send :in, '+.5i'
    end

    def oE(*_args)
      ps '+1'
      ft 'R'
      fi
      send :in, '-.5i'
      send :P
    end

    def iS(*_args)
      send :P
      ps '-1'
      ft 'B'
      nf
      send(:in, '+.5i') if @register['!x'] == 0
    end

    def iE(*_args)
      ps '+1'
      ft 'R'
      fi
      send(:in, '-.5i') if @register['!x'] == 0
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
