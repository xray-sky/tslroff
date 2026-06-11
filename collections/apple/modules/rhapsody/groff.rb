# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 06/20/23.
# Copyright 2023 Typewritten Software. All rights reserved.
#
#
# Rhapsody Platform Overrides
#
# TODO
#   _actually_ using mdoc/doc-* macros. gadzooks. looks like all versions share the same macros though
#   what are default mounted fonts 4 and 5? (first new font mounted to 6)
#

module Rhapsody
  class Troff < Groff

    def initialize(source, **kwargs)
      super
      # these require fonts, character_translations, etc. to be configured first
      @register.merge!(
        {
          'sI' => Register.new(to_u(__unesc_pass1 '\\w\\fC,u*5')),
          'Ti' => Register.new(to_u(__unesc_pass1 '\\w\\fC,u*5')),
          'lS' => Register.new(to_u(__unesc_pass1 "\\w'\\0'u")),
          # doc-ditroff
          'fW' => Register.new(to_u(__unesc_pass1 '\\w\\fC0')),
          # bozo
          'aC' => Register.new(0),
          'aJ' => Register.new(0),
          'aP' => Register.new(0),
          'dZ' => Register.new(0),
          'fV' => Register.new(0),
          'lC' => Register.new(0),
          'nS' => Register.new(0),
          'oM' => Register.new(0),
          'wV' => Register.new(0),
          'Xt' => Register.new(0)
        }
      )
      tr String.new('*\(**')
      ft 'R'
    end

    def init_fp
      super
      mount_font 4, 'BI'
      mount_font 5, 'C'
    end

    def init_cc
      cc
      # TODO we have a local .c2 which prevents @c2 from initializing
      @rc2 = Regexp.quote %(')
      @c2 = %(')
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          'sV' => '\\& \\&',
          'hV' => '\\&\\ \\&',
          'iV' => '\\& \\&',
          'tV' => '\\&\t\\&',
          'z(' => 'z)',
          'z[' => 'z]',
          'z<' => 'z>',
          'aD' => "\\fI\\s#{Font.defaultsize}",
          'aR' => "\\f(CO\\s#{Font.defaultsize}",
          'cM' => "\\f(CB\\s#{Font.defaultsize}",
          'dF' => "\\fR\\s#{Font.defaultsize}",
          'eM' => "\\fI\\s#{Font.defaultsize}",
          'eR' => "\\fC\\s#{Font.defaultsize}",
          'eV' => "\\fC\\s#{Font.defaultsize}",
          'fA' => "\\f(CO\\s#{Font.defaultsize}",
          'fD' => "\\f(CB\\s#{Font.defaultsize}",
          'fL' => "\\f(CB\\s#{Font.defaultsize}",
          'fN' => "\\f(CB\\s#{Font.defaultsize}",
          'fP' => '\\fP\\s0',
          'fS' => '\\s0',
          'fT' => "\\f(CO\\s#{Font.defaultsize}",
          'Hs' => "\\fR\\s#{Font.defaultsize}",
          'iC' => "\\f(CB\\s#{Font.defaultsize}",
          'lI' => '\\fC',
          'lP' => "\\fR\\|(\\|\\fP\\s#{Font.defaultsize}",
          'lp' => "\\fR(\\fP\\s#{Font.defaultsize}",
          'rP' => "\\fR\\|)\\|\\fP\\s#{Font.defaultsize}",
          'rp' => "\\fR)\\fP\\s#{Font.defaultsize}",
          'lB' => "\\fR\\^[\\^\\fP\\s#{Font.defaultsize}",
          'rB' => "\\fR\\^]\\fP\\s#{Font.defaultsize}",
          'mL' => "\\fB\\s#{Font.defaultsize}",
          'nM' => "\\f(CB\\s#{Font.defaultsize}",
          'nO' => "\\fR\\s#{Font.defaultsize}",
          'nT' => '\\s0',
          'pA' => "\\fC\\s#{Font.defaultsize}",
          'Pu' => '\\fR{\\ .\\ ,\\ :\\ ;\\ (\\ )\\ [\\ ]\\ \\fR}',
          'rA' => "\\fR\\s#{Font.defaultsize}",
          'rT' => "\\f(CO\\s#{Font.defaultsize}",
          'sH' => "\\fB\\s#{Font.defaultsize}",
          'sP' => '\\s0',
          'sY' => "\\fB\\s#{Font.defaultsize}",
          'sX' => "\\fR\\s#{Font.defaultsize}",
          'tF' => '\\fR',
          'tN' => '\\s9',
          'vA' => "\\fI\\s#{Font.defaultsize}",
          'Vs' => "\\fR\\s#{Font.defaultsize}",
          'vT' => "\\f(CB\\s#{Font.defaultsize}",
          'xR' => "\\fC\\s#{Font.defaultsize}",
          'lS' => '\\0',
          'Px' => '\\*(tNPOSIX',
          'Ai' => '\\*(tNANSI',
          # mdoc
          't1' => String.new,
          # doc-ditroff
          '<=' => '\\(<=',
          '>=' => '\\(>=',
          'Lq' => '\\(lq',
          'Rq' => '\\(rq',
          'ua' => '\\(ua',
          'aa' => '\\(aa',
          'ga' => '\\(ga',
          'sR' => "\\&'",
          'sL' => "\\&`",
          'q'  => '\\&"',
          'Pi' => '\\(*p',
          'Ne' => '\\(!=',
          'Le' => '\\(<=',
          'Ge' => '\\(>=',
          'Lt' => '<',
          'Gt' => '>',
          'Pm' => '\\(+-',
          'If' => '\\(if',
          'Na' => '\\fINaN\\fP',
          'Ba' => '\\fR\\&|\\fP'
        }
      )
    end

    def init_nr
      @character_translations = {} # temporary, for __unesc_pass1
      @register.merge!(
        {
          '%A' => Register.new(1),
          '%J' => Register.new(1),
          '%N' => Register.new(1),
          '%O' => Register.new(1),
          '%R' => Register.new(1),
          '%T' => Register.new(1),
          '%V' => Register.new(1),
          'Ad' => Register.new(to_u('12n')),
          'Ac' => Register.new(3),
          'Ao' => Register.new(to_u('12n')),
          'Ap' => Register.new(2),
          'An' => Register.new(to_u('12n')),
          'Aq' => Register.new(to_u('12n')),
          'Ar' => Register.new(to_u('12n')),
          'Bc' => Register.new(3),
          'Bl' => Register.new(1),
          'Bo' => Register.new(to_u('12n')),
          'Bq' => Register.new(to_u('12n')),
          'Bx' => Register.new(to_u('12n')),
          'Cd' => Register.new(to_u('12n')),
          'Cm' => Register.new(to_u('10n')),
          'Co' => Register.new(to_u('15n')),
          'Cx' => Register.new(to_u('20n')),
          'Dc' => Register.new(3),
          'Do' => Register.new(to_u('10n')),
          'Dq' => Register.new(to_u('12n')),
          'Ds' => Register.new(to_u('6n')),
          'Dv' => Register.new(to_u('12n')),
          'tI' => Register.new(to_u('6n')),
          'Ec' => Register.new(3),
          'El' => Register.new(1),
          'Eo' => Register.new(to_u('12n')),
          'Eq' => Register.new(to_u('12n')),
          'Em' => Register.new(to_u('10n')),
          'Er' => Register.new(to_u('12n')),
          'Ev' => Register.new(to_u('15n')),
          'Ex' => Register.new(to_u('10n')),
          'Fa' => Register.new(to_u('12n')),
          'Fl' => Register.new(to_u('10n')),
          'Fc' => Register.new(3),
          'Fo' => Register.new(to_u('16n')),
          'Fn' => Register.new(to_u('16n')),
          'Hl' => Register.new(1),
          'I1' => Register.new(to_u('6n')),
          'I2' => Register.new(to_u('12n')),
          'I3' => Register.new(to_u('18n')),
          'Ic' => Register.new(to_u('10n')),
          'Li' => Register.new(to_u('16n')),
          'Ms' => Register.new(to_u('6n')),
          'Nm' => Register.new(to_u('10n')),
          'No' => Register.new(to_u('12n')),
          'Ns' => Register.new(2),
          'Oo' => Register.new(to_u('10n')),
          'Oc' => Register.new(3),
          'Op' => Register.new(to_u('14n')),
          'Pa' => Register.new(to_u('32n')),
          'Pf' => Register.new(to_u('12n')),
          'Pc' => Register.new(3),
          'Po' => Register.new(to_u('12n')),
          'Pq' => Register.new(to_u('12n')),
          'Ql' => Register.new(to_u('16n')),
          'Qc' => Register.new(3),
          'Qo' => Register.new(to_u('12n')),
          'Qq' => Register.new(to_u('12n')),
          'Sc' => Register.new(3),
          'So' => Register.new(to_u('12n')),
          'Sq' => Register.new(to_u('12n')),
          'Sy' => Register.new(to_u('6n')),
          'Sx' => Register.new(to_u('16n')),
          'Ra' => Register.new(1),
          'Rj' => Register.new(1),
          'Rn' => Register.new(1),
          'Ro' => Register.new(1),
          'Rr' => Register.new(1),
          'Rt' => Register.new(1),
          'Rv' => Register.new(1),
          'Tn' => Register.new(to_u('10n')),
          'Ta' => Register.new(1),
          'Tv' => Register.new(1),
          'Tx' => Register.new(to_u('22n')),
          'Ux' => Register.new(to_u('10n')),
          'Va' => Register.new(to_u('12n')),
          'Xc' => Register.new(3),
          'Xo' => Register.new(1),
          'Xr' => Register.new(to_u('10n')),
          'z.' => Register.new(3),
          'z,' => Register.new(3),
          'z:' => Register.new(3),
          'z;' => Register.new(3),
          'z(' => Register.new(4),
          'z)' => Register.new(3),
          'z[' => Register.new(4),
          'z]' => Register.new(3),
          'z0' => Register.new(0),
          'z1' => Register.new(0),
          'z2' => Register.new(0),
          'z3' => Register.new(0),
          'z4' => Register.new(0),
          'z5' => Register.new(0),
          'z6' => Register.new(0),
          'z7' => Register.new(0),
          'z8' => Register.new(0),
          'z9' => Register.new(0),
          'z#' => Register.new(0),
          'Pp' => Register.new(to_u('.5v')),
          'dI' => Register.new(to_u('6n')),
          # mdoc
          'sM' => Register.new(1),
          'w1' => Register.new(0),
          'o1' => Register.new(0),
          'h1' => Register.new(0),
          'v1' => Register.new(0),
          'tY' => Register.new(1),
          # doc-ditroff
          'gX' => Register.new(0)
        }
      )
    end

    # mdoc

    def aV(*args)
      @register['aC'].value += 1
warn ".aV #{args.inspect} - regs: aC #{@register['aC'].inspect} aT #{@register['aT'].inspect} mN #{@named_strings['mN'].inspect}"
      if (args[0] == '|')
        case @named_strings['mN']
        when 'Op', 'Ar', 'Fl', 'Cm', 'It' then parse ".ds A\\n(aC \\fR#{args[0]}\\fP"
        end
      else
         parse ".ds A\\n(aC #{args[0]}"
      end
      parse '.aU \\n(aC'
      parse '.nr C\\n(aC \\n(aT'
      send "s#{@register['aT']}"
      if (@register['Db'] > 0)
        case @register['aT'].value
        when 1 then ds 'yU Executable'
        when 2 then ds 'yU String'
        when 3 then ds 'yU Closing Punctuation or suffix'
        when 4 then ds 'yU Opening Punctuation or prefix'
        end
        if (@register['iN'] == 1)
          br
          parse '.nr iI \\n(.iu'
          parse '.in -\\n(iIu'
          if (@register['aC'] == 1)
            parse "\\&\\fBDEBUG(argv) MACRO:\\fP `.\\*(mN' \\fBLine #:\\fP \\n(.c"
          end
          parse "\\&\t\\fBArgc:\\fP \\n(aC  \\fBArgv:\\fP =\\*(A\\n(aC'  \\fBLength:\fP \\n(sW"
          parse "\\&\t\\fBSpace:\fP =\\*(S\\n(aC'  \\fBClass:\\fP \\*(yU"
        end
        if (@register['iN'] == 0)
          if (@register['aC'] == 1)
            parse ".tm DEBUG(argv) MACRO: `.\\*(mN'  Line #: \\n(.c"
          end
          parse ".tm \tArgc: \\n(aC  Argv: `\\*(A\\n(aC'  Length: \\n(sW"
          parse ".tm \tSpace:  `\\*(S\\n(aC'  Class: \\*(yU"
        end
      end
      if (args.length == 1)
        nr 'aP 0'
        if (@register['dZ'] == 1)
          parse '.as b1 \\*(S0' if @register['oM'] > 1
        else
          parse '.as b1 \\*(S0' if @register['oM'] > 0 and @register['fC'].zero?
        end
        parse '.ds S0 \\*(S\\n(aC'
        if (@register['Db'] > 0)
          if (@register['iN'] == 1)
            parse '\\&MACRO REQUEST: \t.\\*(mN \\*(A1 \\*(A2 \\*(A3 \\*(A4 \\*(A5 \\*(A6 \\*(A7 \\*(A8 \\*(A9'
            br
            send :in, '\\n(iIu'
          end
          if (@register['iN'].zero?)
            parse '.tm \tMACRO REQUEST: .\\*(mN \\*(A1 \\*(A2 \\*(A3 \\*(A4 \\*(A5 \\*(A6 \\*(A7 \\*(A8 \\*(A9'
          end
        end
      else
        parse ".aV #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
      end
    end

    def fV(*_args)
      @register['aC'].value += 1
warn ".fV #{_args.inspect} - regs: aC #{@register['aC'].inspect} aT #{@register['aT'].inspect} mN #{@named_strings['mN'].inspect} A_aC #{@named_strings["A#{@register['aC']}"].inspect}"
      if @named_strings["A#{@register['aC']}"] == '|' ## TODO IMPORTANT groff string equality includes formatting equivalencies! e.g. "\fRa\fP" == "a"
        case @named_strings['mN']
        when 'Op', 'Ar', 'Cm', 'It' then parse '.ds A\\n(aC \\fR\\*(A\\n(aC\\fP'
        when 'Fl'                   then parse '.ds A\\n(aC \\fR\\&\\*(A\\n(aC\\fP'
        end
      end
      parse '.aU \\n(aC'
      parse '.nr C\\n(aC \\n(aT'
      parse '.s\\n(aT'
      if @register['Db'] > 0
        case @register['aT'].value
        when 1 then parse '.ds yU Executable'
        when 2 then parse '.ds yU String'
        when 3 then parse '.ds yU Closing Punctuation or suffix'
        when 4 then parse '.ds yU Opening Punctuation or prefix'
        end
        if @register['iN'] == 1
          br
          parse '.nr iI \\n(.iu'
          parse '.in -\\n(iIu'
          parse "\\&\\fBDEBUG(fargv) MACRO:\\fP `.\\*(mN'  \\fBLine #:\\fP \\n(.c" if @register['aC'] == 1
          parse "\\&\t\\fBArgc:\\fP \\n(aC  \\fBArgv:\\fP `\\*(A\\n(aC'  \\fBLength:\\fP \\n(sW"
          parse "\\&\t\\fBSpace:\\fP `\\*(S\\n(aC'  \\fBClass:\\fP \\*(yU"
        end
        if @register['iN'].zero?
          parse ".tm DEBUG(fargv) MACRO: `.\\*(mN'  Line #: \\n(.c" if @register['aC'] == 1
          parse ".tm \tArgc: \\n(aC  Argv: `\\*(A\\n(aC'  Length: \\n(sW"
          parse ".tm \tSpace: `\\*(S\\n(aC'  Class: \\*(yU"
        end
      end
      if @register['fV'] == 1
        nr 'aP 0'
        if @register['dZ'] == 1
          parse '.as b1 \\*(S0' if @register['oM'] > 1
        else
          parse '.as b1 \\*(S0' if @register['oM'] > 1 and @register['fC'].zero?
        end
        parse '.ds S0 \\*(S\\n(aC'
        nr 'fV 0'
        if @register['Db'] > 0
          if @register['iN'] > 0
            parse '\\&\tMACRO REQUEST: .\\*(mN \\*(A1 \\*(A2 \\*(A3 \\*(A4 \\*(A5 \\*(A6 \\*(A7 \\*(A8 \\*(A9'
            br
            parse '.in \\n(iIu'
          else
            parse '.tm \tMACRO REQUEST: .\\*(mN \\*(A1 \\*(A2 \\*(A3 \\*(A4 \\*(A5 \\*(A6 \\*(A7 \\*(A8 \\*(A9'
          end
        end
      else
        @register['fV'].value -= 1
        fV
      end
    end

    def aX(*_args)
warn ".#{__callee__} #{_args.inspect}"
      @register['aP'].value += 1
      parse '.as b1 \\&\\*(A\\n(aP'
      if @register['fV'] == 1
        nr 'aP 0'
        nr 'fV 0'
      else
        parse '.as b1 \\&\\*(sV'
        @register['fV'].value -= 1
        aX
      end
    end

    def aI(*args)
warn ".#{__callee__} #{args.inspect}"
      if @register['aC'] < 9
        @register['aC'].value += 1
        parse ".ds A\\n(aC #{args[0]}"
        parse ".ds C\\n(aC #{args[1]}"
        parse ".s#{args[1]}"
        parse '.ds xV S\\n(aC'
      else
        tm 'Usage: Too many arguments (maximum of 8 accepted) (#\\n(.c)'
        parse '.tm \\*(A1 \\*(A2 \\*(A3 \\*(A4 \\*(A5 \\*(A6 \\*(A7 \\*(A8 \\*(A9'
      end
    end

    def aZ(*_args)
warn ".#{__callee__} #{_args.inspect}"
      pB
      aY
    end

    def aY(*_args)
warn ".#{__callee__} #{_args.inspect}"
      rm 'C0 C1 C2 C3 C4 C5 C6 C7 C8 C9'
      rm 'A0 A1 A2 A3 A4 A5 A6 A7 A8 A9'
      rm 'S1 S2 S3 S4 S5 S6 S7 S8 S9'
      nr 'aC 0'
      nr 'aP 0'
    end

    def pB(*_args)
warn ".#{__callee__} #{_args.inspect}"
      if (@register['dZ'] == 1)
        if (@register['oM'] == 1)
          parse '\\&\\*(b1'.tap {|x| warn "pB (A) parsing #{@named_strings['b1'].inspect}" }
          rm 'S0'
          ds 'b1'
        end
        x2 if (@register['oM'] == 0)
      else
        if (@register['oM'] == 0)
          parse '\\&\\*(b1'.tap {|x| warn "pB (B) parsing #{@named_strings['b1'].inspect}" }
          rm 'S0'
          ds 'b1'
        else
          x1 if (@register['sM'] == 1 and @register['tP'].zero?)
        end
      end
      # hy
    end

    def x1(*_args)
warn ".#{__callee__} #{_args.inspect}"
      @register['dZ'].value += 1
      parse '.ds b2 \\*(b1'
      ds b1
      parse '.nr lK \\n(.c'
      ev '2'
      fi
      di 'eB'
    end

    def x2(*_args)
warn ".#{__callee__} #{_args.inspect}"
      br
      di
      ev
      if (@register['.c'] - @register['lK'].value > 1)
        parse '.ds b0 \\^\\*(eB\\'
        parse '.ds b1 \\*(b2\\*(b0\\*(b1'
      else
        parse '.ds b1 \\*(b2\\*(b1'
      end
      parse '\\&\\*(b1'
      rm 'eB b2 b0 b1'
      @register['dZ'].value -= 1
    end

    def Fl(*args)
warn ".#{__callee__} #{args.inspect}"
      parse '.as b1 \\&\\*(fL'
      if @register['aC'].zero?
        if args.empty?
          parse '.as b1 \\&\\|\\-\\|\\fP\\s0'
          pB
        else
          ds 'mN Fl'
          parse ".aV #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
        end
      end
      if @register['aC'] > 0
        if @register['aC'] - @register['aP'].value == 0
          parse '.as b1 \\&\\|\\-\\fP\\s0'
          aZ
        else
          @register['aP'].value += 1
          if @register["C#{@register['aP']}"] == 1
            parse '.as b1 \\&\\|\\-\\fP\\s0'
            parse '.\\*(A\\n(aP'
          else
            parse '.nr cF \\n(.f'
            parse '.nr cZ \\n(.s'
            parse '.as b1 \\&\\|\\-\\|' if @register["C#{@register['aP']}"] == 3
            fR
          end
        end
      end
    end

    def fR(*args)
warn ".#{__callee__} #{args.inspect}"
      #hy '0'
      parse '.nr jM \\n(C\\n(aP'
      if @register['jM'] == 1
        as 'b1 \\&\\fP\\s0'
        parse '.\\*(A\\n(aP'
      else
        parse '.nr jM \\n(aP'
        if @register['jM'] == 2
          if __unesc_pass1('\\*(A\\n(aP') != __unesc_pass1('\\*(Ba') # REVIEW
            if __unesc_pass1('\\*(A\\n(aP') != __unesc_pass1('\\fR|\\fP') # REVIEW
              if __unesc_pass1('\\*(A\\n(aP') == '-'
                as 'b1 \\&\\|\\-\\^\\-\\|'
              else
                parse '.as b1 \\&\\|\\-\\*(A\\n(aP'
              end
            else
              parse '.as b1 \\&\\*(A\\n(aP'
            end
          else
            parse '.as b1 \\&\\*(A\\n(aP'
          end
        else
          parse '.as b1 \\&\\f\\n(cF\\s\\n(cZ\\*(A\\n(aP\\fP\\s0'
        end
        if @register['aC'] == @register['aP'].value
          as 'b1 \\&\\|\\-' if @register['jM'] == 4
          as 'b1 \\&\\fP\\s0'
          aZ
        else
          @register['aP'].value += 1
          if @register["C#{@register['aP']}"] == 3 and @register["C#{@register['jN']}"] == 4
            as 'b1 \\&\\|\\-'
          else
            parse '.as b1 \\&\\*(S\\n(jN'
            parse ".fR #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
          end
        end
      end
      rr 'jM jN'
    end

    def nR(*_args)
warn ".#{__callee__} #{_args.inspect}"
      #hy '0'
      parse '.nr jM \\n(C\\n(aP'
      if (@register['jM'] == 1)
        parse '.as b1 \\&\\f\\n(cF\\s\\n(cZ'
        parse '\\*(A\\n(aP'
      else
        parse '.nr jN \\n(aP'
        if (@register['jM'] == 2)
          parse '.as b1 \\&\\*(A\\n(aP'
        else
          parse '.as b1 \\&\\f\\n(cF\\s\\n(cZ\\*(A\\n(aP\\fP\\s0'
        end
        if (@register['aC'] == @register['aP'].value)
          parse '.as b1 \\&\\f\\n(cF\\s\\n(cZ'
          aZ
        else
          @register['aP'].value += 1
          parse '.as b1 \\&\\*(S\\n(jN'
          nR
        end
      end
      rr 'jM jN'
    end

    def Ar(*args)
warn ".#{__callee__} #{args.inspect}"
      parse '.as b1 \\*(aR'
      if @register['aC'].zero?
        if args.empty?
          parse '.as b1 file\\ ...\\fP\\s0'
          pB
        else
          ds 'mN Ar'
          parse ".aV #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
        end
      end
      if @register['aC'] > 0
        if @register['aC'] - @register['aP'].value == 0
          parse '.as b1 \\&file\\ ...\\fP\\s0'
          aZ
        else
          @register['aP'].value += 1
          if @register["C#{@register['aP']}"] == 1
            parse '.as b1 \\&file\\ ...\\fP\\s0'
warn "Ar == #{@named_strings["A#{@register['aP']}"]            .inspect}"
            parse '.\\*(A\\n(aP'
          else
            parse '.nr cF \\n(.f'
            parse '.nr cZ \\n(.s'
            parse '.as b1 \\&file\\ ...' if @register["C#{@register['aP']}"] == 3
            nR
          end
        end
      end
    end

=begin
    def Ad(*_args)
    end

    def Cd(*_args)
    end

    def Cm(*_args)
    end

    def Dv(*_args)
    end

    def Em(*_args)
    end

    def Er(*_args)
    end

    def Ev(*_args)
    end

    def Fd(*_args)
    end

    def Fr(*_args)
    end

    def Ic(*_args)
    end

    def Li(*_args)
    end

    def Or(*_args)
    end

    def Ms(*_args)
    end
=end

    # copies args to .nr A[1-9], with .nr fV == args.length
    # builds name into .ds n1; font setup to nM; something something aC, aP, indents
    def Nm(*args)
warn ".#{__callee__} #{args.inspect}"
      if @register['aC'].zero?
        if args.empty?
          if @named_strings['n1'].empty?
            parse '.tm Usage: .Nm Name(s) ... \\*(Pu (#\\n(.c)'
          else
            parse '\\&\\*(nM\\*(n1\\fP\\s0'
          end
        else
          ds 'mN Nm'
          ds "A1 #{args[0]}"
          ds "A2 #{args[1]}"
          ds "A3 #{args[2]}"
          ds "A4 #{args[3]}"
          ds "A5 #{args[4]}"
          ds "A6 #{args[5]}"
          ds "A7 #{args[6]}"
          ds "A8 #{args[7]}"
          ds "A9 #{args[8]}"
          nr "fV #{args.length}"
          fV
        end
      end
      if @register['aC'] > 0
        if @register['aC'] == @register['aP'].value
          parse '.as b1 \\&\\*(nM\\*(n1\\fP\\s0'
          aZ
        else
          parse '.as b1 \\*(nM'
          @register['aP'].value += 1
          if @register["C#{@register['aP']}"] == 1
            parse '.as b1 \\&*\\*(n1\\fP\\s0'
            parse '\\*(A\\n(aP'
          else
            parse '.nr cF \\n(.f'
            parse '.nr cZ \\n(.s'
            if @register['nS'] > 0 and @named_strings['mN'] == 'Nm'
              rs
              parse '.in -\\n(iSu'
              if @register['nS'] > 1
                br
              else
                if @register['.iS'].zero?
                  #sw args[0] # REVIEW ??
                  parse '.nr iS ((\\n(sWu+1)*\\n(fW)u'
                end
              end
              parse '.in +\\n(iSu'
              parse '.ti -\\n(iSu'
              @register['nS'].value += 1
            end
          end
          parse '.ds n1 \\*(A\\n(aP' if @named_strings['n1'].empty?
          nR
        end
      end
    end

=begin
    def Pa(*_args)
    end

    def Sy(*_args)
    end
=end

    def Tn(*args)
warn ".#{__callee__} #{args.inspect}"
      if @register['aC'].zero?
        if args.empty?
          parse '.tm Usage: .Tn Trade_name(s) ... \\*(Pu (#\\n(.c)'
        else
          ds 'mN Tn'
          parse ".aV #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
        end
      end
      if @register['aC'] > @register['aP'].value
        parse '.as b1 \\*(tN\\*(tF'
        @register['aP'].value += 1
        parse '.nr cF \\n(.f'
        parse '.nr cZ \\n(.s'
        nR
      end
    end

    def nN(*args)
warn ".#{__callee__} #{args.inspect}"
      if @register['aC'].zero?
        if args.empty?
          parse '.tm Usage: .Tn Trade_name(s) ... \\*(Pu (#\\n(.c)'
        else
          ds 'mN Tn'
          parse ".aV #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
        end
      end
      if @register['aC'] > @register['aP'].value
        parse '.as b1 \\*(tN'
        @register['aP'].value += 1
        parse '.nr cF \\n(.f'
        parse '.nr cZ \\n(.s'
        rR
      end
    end

    def Va(*args)
warn ".#{__callee__} #{args.inspect}"
      if @register['aC'].zero?
        if args.empty?
          parse '.tm Usage: .Va variable_name(s) ... \\*(Pu (#\\n(.c)'
        else
          ds 'mN Va'
          parse ".aV #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
        end
      end
      if @register['aC'] > @register['aP'].value
        parse '.as b1 \\*(vA'
        @register['aP'].value += 1
        parse '.nr cF \\n(.f'
        parse '.nr cZ \\n(.s'
        nR
      end
    end

    def No(*args)
warn ".#{__callee__} #{args.inspect}"
      parse '.as b1 \\*(nO'
      if @register['aC'].zero?
        if args.empty?
          parse '.tm Usage: .No must be called with arguments (#\\n(.c)'
        else
          ds 'mN No'
          parse ".aV #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
        end
      end
      if @register['aC'] > @register['aP'].value
        @register['aP'].value += 1
        if @register["C#{@register['aP']}"] == 1
          parse '.\\*(A\\n(aP'
        else
          parse '.nr cF \\n(.f'
          parse '.nr cZ \\n(.s'
          nR
        end
      end
    end

    def Op(*args)
warn ".#{__callee__} #{args.inspect}"
      ds 'mN Op' if @register['aC'].zero?
      parse '.ds qL \\&\\*(lB'
      parse '.ds qR \\&\\*(rB'
      parse ".En #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]}"
    end

    def Aq(*args)
warn ".#{__callee__} #{args.inspect}"
      ds 'mN Aq' if @register['aC'].zero?
      parse '.ds qL \\&<'
      parse '.ds qR \\&>'
      parse ".En #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
    end

    def Bq(*args)
warn ".#{__callee__} #{args.inspect}"
      ds 'mN Bq' if @register['aC'].zero?
      parse '.ds qL \\&\\*(lB'
      parse '.ds qR \\&\\*(rB'
      parse ".En #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
    end

    def Dq(*args)
warn ".#{__callee__} #{args.inspect}"
      ds 'mN Dq' if @register['aC'].zero?
      parse '.ds qL \\&\\*(Lq'
      parse '.ds qR \\&\\*(Rq'
      parse ".En #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
    end

    def Eq(*args)
warn ".#{__callee__} #{args.inspect}"
      ds 'mN Eq' if @register['aC'].zero?
      parse ".ds qL #{args[0]}"
      parse ".ds qR #{args[1]}"
      parse ".En #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
    end

    def Pq(*args)
warn ".#{__callee__} #{args.inspect}"
      ds 'mN Pq' if @register['aC'].zero?
      parse '.ds qL \\&\\*(lP'
      parse '.ds qR \\&\\*(rP'
      parse ".En #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
    end

    def Qq(*args)
warn ".#{__callee__} #{args.inspect}"
      ds 'mN Qq' if @register['aC'].zero?
      parse '.ds qL \\&\\*q'
      parse '.ds qR \\&\\*q'
      parse ".En #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
    end

    def Sq(*args)
warn ".#{__callee__} #{args.inspect}"
      ds 'mN Sq' if @register['aC'].zero?
      parse '.ds qL \\&\\*(sL'
      parse '.ds qR \\&\\*(sR'
      parse ".En #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
    end

    def Es(*args)
warn ".#{__callee__} #{args.inspect}"
      if @register['aC'].zero?
        if args.length > 2
          parse ".aV #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
        else
          ds "qL #{args[0]}"
          ds "qR #{args[1]}"
        end
      end
      if @register['aC'] > @register['aP'].value
        @register['aP'].value += 1
        parse '.ds qL \\*(A\\n(aP'
        @register['aP'].value += 1
        parse '.ds qR \\*(A\\n(aP'
        if @register['aC'] > @register['aP'].value
          parse '.c\\n(C\\n(aP'
        else
          aZ
        end
      end
    end

    def En(*args)
warn ".#{__callee__} #{args.inspect}"
      if @register['aC'].zero?
        if args.empty?
          parse '.as b1 \\&\\*(qL\\*(qR'
          pB
        else
          parse ".aV #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
          parse '.as b1 \\&\\*(qL'
        end
      else
        parse '.as b1 \\&\\*(qL'
      end
      if @register['aC'] > 0
        if @register['aC'] - @register['aP'].value == 0
          parse '.as b1 \\&\\*(qR'
          aZ
        else
          if @register["C#{@register['aC']}"] == 3
            parse '.nr aJ \\n(aC-1'
            vR
            @register['aJ'].value += 1
            parse '.ds A\\n(aJ \\&\\*(qR\\*(A\\n(aJ'
            nr 'aJ 0'
          else
            parse '.aI \\&\\*(qR 3'
          end
          @register['aP'].value += 1
          parse '.\\*(A\\n(aP' if @register["C#{@register['aP']}"] == 1
          if @register["C#{@register['aP']}"] > 1
            @register['aP'].value -= 1
            send :No
          end
        end
      end
    end

    def vR(*_args)
warn ".#{__callee__} #{_args.inspect}"
      if @register["C#{@register['aJ']}"] == 3
        @register['aJ'].value -= 1
        vR
      end
    end

    def Ao(*args)
warn ".#{__callee__} #{args.inspect}"
      ds 'mN Ao' if @register['aC'].zero?
      ds 'qL \\&<'
      parse ".eO #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
    end

    def Ac(*args)
warn ".#{__callee__} #{args.inspect}"
      ds 'mN Ac' if @register['aC'].zero?
      ds 'qR \\&>'
      parse ".eC #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
    end

    def Bo(*args)
warn ".#{__callee__} #{args.inspect}"
      ds 'mN Bo' if @register['aC'].zero?
      ds 'qL \\&['
      parse ".eO #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
    end

    def Bc(*args)
warn ".#{__callee__} #{args.inspect}"
      ds 'mN Bc' if @register['aC'].zero?
      ds 'qR \\&]'
      parse ".eC #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
    end

    def Do(*args)
warn ".#{__callee__} #{args.inspect}"
      ds 'mN Do' if @register['aC'].zero?
      ds 'qL \\&\\*(Lq'
      parse ".eO #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
    end

    def Dc(*args)
warn ".#{__callee__} #{args.inspect}"
      ds 'mN Dc' if @register['aC'].zero?
      ds 'qR \\&\\*(Rq'
      parse ".eC #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
    end

    def Eo(*args)
warn ".#{__callee__} #{args.inspect}"
      ds 'mN Eo' if @register['aC'].zero?
      ds "qL #{args[0]}"
      parse ".eO #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
    end

    def Ec(*args)
warn ".#{__callee__} #{args.inspect}"
      ds 'mN Ec' if @register['aC'].zero?
      ds "qR #{args[0]}"
      parse ".eC #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
    end

    def Oo(*args)
warn ".#{__callee__} #{args.inspect}"
      ds 'mN Oo' if @register['aC'].zero?
      ds 'qL \\&['
      parse ".eO #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
    end

    def Oc(*args)
warn ".#{__callee__} #{args.inspect}"
      ds 'mN Oc' if @register['aC'].zero?
      ds 'qR \\&]'
      parse ".eC #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
    end

    def Po(*args)
warn ".#{__callee__} #{args.inspect}"
      ds 'mN Po' if @register['aC'].zero?
      ds 'qL \\&('
      parse ".eO #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
    end

    def Pc(*args)
warn ".#{__callee__} #{args.inspect}"
      ds 'mN Pc' if @register['aC'].zero?
      ds 'qR \\&)'
      parse ".eC #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
    end

    def Qo(*args)
warn ".#{__callee__} #{args.inspect}"
      ds 'mN Qo' if @register['aC'].zero?
      ds 'qL \\&\\*q'
      parse ".eO #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
    end

    def Qc(*args)
warn ".#{__callee__} #{args.inspect}"
      ds 'mN Qc' if @register['aC'].zero?
      ds 'qR \\&\\*q'
      parse ".eC #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
    end

    def So(*args)
warn ".#{__callee__} #{args.inspect}"
      ds 'mN So' if @register['aC'].zero?
      ds 'qL \\&\\*(sL'
      parse ".eO #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
    end

    def Sc(*args)
warn ".#{__callee__} #{args.inspect}"
      ds 'mN Sc' if @register['aC'].zero?
      ds 'qR \\&\\*(sR'
      parse ".eC #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
    end

    def Xo(*args)
warn ".#{__callee__} #{args.inspect}"
      ds 'mN Xo' if @register['aC'].zero?
      ds 'qL'
      parse ".eO #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
    end

    def Xc(*args)
warn ".#{__callee__} #{args.inspect}"
      ds 'mN Xc' if @register['aC'].zero?
      ds 'qR'
      parse ".eC #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
    end

    def eO(*args)
warn ".#{__callee__} #{args.inspect}"
      @register['oM'].value += 1
      if @register['aC'].zero?
        if args.any?
          parse ".aV #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
          parse '.as b1 \\*(qL'
        else
          parse '.as b1 \\*(qL'
          if @register['dZ'].zero? and @register['sM'] == 1
            @register['dZ'].value += 1
            parse '.ds b2 \\*(b1'
            ds 'b1'
            parse '.nr lK \\n(.c'
            ev '2'
            fi
            di 'eB'
          end
        end
      else
        parse '.as b1 \\*(qL'
      end
      if @register['aC'] > 0
        if @register['aC'] > @register['aP'].value
          @register['aP'].value += 1
          if @register["C#{@register['aP']}"] == 1
            parse '.\\*(A\\n(aP'
          else
           @register['aP'].value -= 1
           send :No
          end
        end
        if @register['aC'] == @register['aP'].value
          nr 'Xt 1' if @register['tP'] == 1
          aY
        end
      else
        parse '.as b1 \\*(sV' if @register['oM'] > 1
      end
    end

    def eC(*args)
warn ".#{__callee__} #{args.inspect}"
      @register['oM'].value -= 1
      parse '.as b1 \\*(qR'
      if @register['aC'].zero?
        if args.any?
          parse ".aV #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
        else
          if @named_strings['xB'].empty?
            pB
          else
            pB
            parse '.\\*(L\\n(lC'
            nr 'Xt 0'
            ds 'xB'
          end
        end
      end
      if @register['aC'] > 0
        if @register['aC'] == @register['aP'].value
          if @register['oM'].zero?
            aZ
          else
            aY
          end
        else
          parse '.nr aa \\n(aP+1'
          parse '.as b1 \\*(S\\n(aC' if @register["C#{@register['aa']}"] == 2
          rr 'aa'
          @register['Xt'] -= 1 if @register['tP'] > 0 and @register['Xt'] > 0
          send :No
        end
      end
    end

=begin
    def Pf(*_args)
    end

    def pF(*_args)
    end

    def Ns(*_args)
    end

    def Ap(*_args)
    end
=end

    def Hv(*_args)
warn ".#{__callee__} #{_args.inspect}"
      ds 'iV \\*(sV'
      ds 'sV \\*(hV'
    end

    def Sv(*_args)
warn ".#{__callee__} #{_args.inspect}"
      ds 'sV \\*(iV'
    end

    def Tv(*_args)
warn ".#{__callee__} #{_args.inspect}"
      ds 'sV \\*(tV'
    end

=begin
    def Sm(*args)
    end
=end

    def aT(*args)
warn ".#{__callee__} #{args.inspect}"
      nr 'aT 0'
      if (@register['sW'] > 2 or !identifier?(args[0]))
        nr 'aT 2'
      else
        if (@register['sW'] == 1)
          if (@register["z#{args[0]}"] > 2)
            parse ".nr aT \\n(z#{args[0]}"
          else
            nr 'aT 2'
          end
        end
        if (@register['sW'] == 2)
          if (@register[args[0]] > 0)
            nr 'aT 1'
          else
            nr 'aT 2'
          end
        end
      end
    end

    def aU(*args)
warn ".#{__callee__} #{args.inspect}"
      nr 'aT 0'
      aW args[0]
      if (@register['sW'] > 2 or !identifier?(@named_strings["A#{args[0]}"]))
        nr 'aT 2'
      else
        if (@register['sW'] == 1)
          if (@register["z#{@named_strings["A#{args[0]}"]}"] > 2)
            parse ".nr aT \\n(z\\*(A#{args[0]}"
          else
            nr 'aT 2'
          end
        end
        if (@register['sW'] == 2)
          if (@register["#{@named_strings["A#{args[0]}"]}"] > 0)
            nr 'aT 1'
          else
            nr 'aT 2'
          end
        end
      end
    end

    def s0(*_args)
warn ".#{__callee__} #{_args.inspect}"
      parse ".tm MDOC-ERROR: bogus type 0 (can't set space '\\*(A\\n(aC') (#\\n(.c)"
    end

    def s1(*_args)
warn ".#{__callee__} #{_args.inspect} -- aC #{@register['aC'].inspect}"
      if (@register["#{@named_strings["A#{@register['aC']}"]}"] == 3)
        parse '.nr xX \\n(aC-1'
        parse '.rm S\\n(xX'
        parse '.ds S\\n(aC \\*(sV'
      end
      if (@register["#{@named_strings["A#{@register['aC']}"]}"] == 2)
        parse '.nr xX \\n(aC-1'
        if (@named_strings["A#{@register['aC']}"] == 'Nb')
          parse '.ds S\\n(xX \\*(hV'
        else
          parse '.rm S\\n(xX'
        end
      end
    end

    def s2(*_args)
warn ".#{__callee__} #{_args.inspect} -- aC #{@register['aC'].inspect}"
      parse '.ds S\\n(aC \\*(sV'
    end

    def s3(*_args)
warn ".#{__callee__} #{_args.inspect} -- aC #{@register['aC'].inspect}"
      if (@register['aC'] > 1)
        parse '.nr xX \\n(aC-1'
        parse '.rm S\\n(xX'
      end
      parse '.ds S\\n(aC \\*(sV'
    end

    def s4(*_args)
warn ".#{__callee__} #{_args.inspect}"
      nr 'aa 0'
    end

    def c0(*_args)
warn ".#{__callee__} #{_args.inspect}"
      parse ".tm MDOC-ERROR: bogus class 0 (can't determine '\\*(A\\n(aC') (#\\n(.c)"
    end

    def c1(*_args)
warn ".#{__callee__} #{_args.inspect}"
      parse '.\\*(A\\n(aP'
    end

    # Overrides standard troff macro for non-breaking request char .c2
    def c2(*_args)
warn ".#{__callee__} #{_args.inspect}"
      parse '.nr aP \\n(aP-1'
      send :No
    end

    def c3(*_args)
warn ".#{__callee__} #{_args.inspect}"
      parse '.nr aP \\n(aP-1'
      send :No
    end

    def c4(*_args)
warn ".#{__callee__} #{_args.inspect}"
      parse '.nr aP \\n(aP-1'
      send :No
    end

    def y1(*_args)
warn ".#{__callee__} #{_args.inspect}"
      nr 'aa 1'
    end

    def y2(*_args)
warn ".#{__callee__} #{_args.inspect}"
      nr 'aa 1'
    end

    def y3(*_args)
warn ".#{__callee__} #{_args.inspect}"
      parse '.as b1 \\*(A\\n(aP'
      @register['aP'].value += 1
      parse '.n\\C\\n(aP'
    end

    def y4(*_args)
warn ".#{__callee__} #{_args.inspect}"
      parse '.as b1 \\*(A\\n(aP'
      @register['aP'].value += 1
      parse '.n\\C\\n(aP'
    end

=begin
    def Bf(*_args)
    end
=end

    def tY(*_args)
warn ".#{__callee__} #{_args.inspect}"
      parse '.nr tY (\\n(lC+1)'
      parse '.nr w\\n(tY 0'
      parse '.nr h\\n(tY 0'
      parse '.nr o\\n(tY 0'
      parse '.ds t\\n(tY \\*(t\\n(lC'
      parse '.ds L\\n(tY'
      parse '.nr v\\n(tY 0'
    end

    def tZ(*_args)
warn ".#{__callee__} #{_args.inspect}"
      parse 'rm L\\n(tY'
      parse 'rr w\\n(tY'
      parse 'rr h\\n(tY'
      parse 'rr o\\n(tY'
      parse 'rm t\\n(tY'
      parse 'rr v\\n(tY'
      @register['tY'].value -= 1
    end

    def Xr(*args)
warn ".#{__callee__} #{args.inspect}"
      if @register['aC'].zero?
        if args.empty?
          parse '.tm Usage: .Xr manpage_name [Section#] \\*(Pu (#\\n(.c)'
        else
          ds 'mN Xr'
          parse ".aV #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
        end
      end

      if (@register['aC'] > @register['aP'].value)
        @register['aP'].value += 1
        if (@register["C#{@register['aP']}"] == 1)
          parse '.tm Usage .Xr manpage_name [section#] \\*(Pu (#\\n(.c)'
        else
          if (@register["C#{@register['aP']}"] > 2)
            send "y#{@register["C#{@register['aP']}"]}"
          else
            parse '.as b1 \\&\\*(xR\\*(A\\n(aP\\fP\\s0'
            if (@register['aC'] > @register['aP'].value)
              @register['aP'].value += 1
              if (@register["C#{@register['aP']}"] == 2)
                parse '.as b1 \\&(\\*(A\\n(aP)'
                @register['aP'].value += 1
              end
              if (@register['aC'] >= @register['aP'].value)
                send "c#{@register["C#{@register['aP']}"]}"
              end
            end
          end
          aZ
        end
      end
    end

=begin

  ...

=end

    def Bl(*args)
warn ".#{__callee__} #{args.inspect}"
      if args.empty?
        tm 'Usage: .Bl [[-hang | -tag] [-width]] [ -item | -wnum | -bullet | -diag] (#\\n(.c)'
      else
        ds 'mN Bl'
        nr 'aP 0'
        @register['lC'].value += 1
        ds "A1 #{args[1]}"
        ds "A2 #{args[2]}"
        ds "A3 #{args[3]}"
        ds "A4 #{args[4]}"
        ds "A5 #{args[5]}"
        ds "A6 #{args[6]}"
        ds "A7 #{args[7]}"
        ds "A8 #{args[8]}"
        nr "fV #{args.length - 1}"
        case args[0]
        when '-hang'
          @register['aP'].value += 1
          parse '.ds L\\n(lC hL'
          parse '.nr w\\n(lC 6n'
          nr 'tC 1'
        when '-tag'
          @register['aP'].value += 1
          parse '.ds L\\n(lC tL'
          nr 'tC 1'
        when '-item'
          @register['aP'].value += 1
          parse '.ds L\\n(lC iT'
          nr 'tC 1'
        when '-enum'
          @register['aP'].value += 1
          parse '.ds L\\n(lC nU'
          parse '.nr w\\n(lC 3n'
          nr 'tC 1'
        when '-bullet'
          @register['aP'].value += 1
          parse '.ds L\\n(lC bU'
          parse '.nr w\\n(lC 2n'
          nr 'tC 1'
        when '-dash', '-hyphen'
          @register['aP'].value += 1
          parse '.ds L\\n(lC hU'
          parse '.nr w\\n(lC 2n'
          nr 'tC 1'
        when '-inset'
          @register['aP'].value += 1
          parse '.ds L\\n(lC lL'
          nr 'tC 1'
        when '-diag'
          @register['aP'].value += 1
          parse '.ds L\\n(lC mL'
          nr 'mL 1'
        when '-ohang'
          @register['aP'].value += 1
          parse '.ds L\\n(lC oL'
          nr 'tC 1'
        when '-column'
          @register['aP'].value += 1
          parse '.ds L\\n(lC cL'
        end
        if @register['aP'].zero?
          tm "#{@args[0]} #{@args[1]} #{@args[2]} #{@args[3]} #{@args[4]} #{@args[5]} #{@args[6]} #{@args[7]} #{@args[8]}"
          tm 'Usage: .Bl [[-inset|-tag] -width] [-item|-enum|-bullet|-diag] (#\\n(.c)'
        else
          tY
          if @register['aP'] == 1 and @register['aP'] < args.length
            nr 'aP 0'
            lV
            if @named_strings["L#{@register['lC']}"] == 'cL'
              parse '.W\\n(wV'
              parse '.nr w\\n(lC 0'
              parse '.in -\\n(eWu'
              if @register["v#{@register['lC']}"] == 1
                nr 'aa 0'
              else
                parse '.sp \\n(dVu'
              end
              nf
              nr 'wV 0'
            end
          end
        end
        nr 'aP 0'
        aY
      end
    end

    def lV(*_args)
warn ".#{__callee__} #{_args.inspect} -- fV #{@register['fV'].inspect} aP #{@register['aP'].inspect}"
      @register['aP'].value += 1
      if @register['fV'] >= @register['aP'].value
        nr 'iD 0'
        case @named_strings["A#{@register['aP']}"]
        when '-compact'
          nr 'iD 1'
          parse '.nr v\\n(lC 1'
        when '-width'
          nr 'iD 1'
          @register['aP'].value += 1
          nr 'tW 1'
          parse '.ds t\\n(lC TagwidtH'
          parse '.ds tS \\*(A\\n(aP'
          parse '.aW \\n(aP'
          if @register['sW'] > 2
            parse '.nr w\\n(lC (\\n(sW)*\\n(fWu'
            if @register['sW'] == 3
              parse '.nr w\\n(lC \\*(tS' if identifier?(__unesc_pass1 '\\*(tS') # and  .if r num!\\*(tS ## ??? TODO REVIEW
            end
          else
            parse '.aT \\*(tS'
            if @register['aT'] == 1
              parse '.nr w\\n(lC \\n(\\*(tS'
            else
              parse '.nr w\\n(lC \\*(tSu'
            end
          end
        when '-offset'
          nr 'iD 1'
          @register['aP'].value += 1
          if @named_strings["A#{@register['aP']}"] == 'indent'
            parse '.nr o\\n(lC \\n(Dsu'
          else
            parse '.ds tS \\*(A\\n(aP'
            parse '.aW \\n(aP'
            if @register['sW'] > 2
              parse '.nr o\\n(lC (\\n(sW)*\\n(fWu'
              parse '.nr o\\n(lC \\*(tS' if identifier?(__unesc_pass1 '\\*(tS') # and  .if r num!\\*(tS ## ??? TODO REVIEW
            else
              if @register["C#{@register['aP']}"] == 1
                parse '.nr o\\n(lC \\n(\\*(tS'
              else
                parse '.nr o\\n(lC \\*(tS'
              end
            end
          end
        end
        if @register['iD'].zero? and @named_strings["L#{@register['lC']}"] == 'cL'
          @register['wV'].value += 1
          parse '.ds A\\n(wV \\*(A\\n(aP'
        end
        lV if @register['fV'] > @register['aP'].value
      end
    end

    #def El(*_args)
    #end

    def It(*args)
warn ".#{__callee__} #{args.inspect}"
      if @named_strings["L#{@register['lC']}"].empty?
        tm 'Usage .Bl -list-type [-width [string] | -compact | -offset [string]] (@\\n(.c)'
        parse ".tm .It #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
      end
      #ne '3v'
      if args.any?
        ds 'mN It'
        ds 'b1'
        nr 'iD 0'
        ds "A1 #{args[0]}"
        ds "A2 #{args[1]}"
        ds "A3 #{args[2]}"
        ds "A4 #{args[3]}"
        ds "A5 #{args[4]}"
        ds "A6 #{args[5]}"
        ds "A7 #{args[6]}"
        ds "A8 #{args[7]}"
        ds "A9 #{args[8]}"
        nr "fV #{args.length}"
        case @named_strings["L#{@register['lC']}"]
        when 'mL'
          nr 'iD 1'
          nr 'aP 0'
          aX
          parse '.\\*(L\\n(lC'
        when 'cL'
          ds 'b1'
          nr 'aP 0'
          nr 'iD 1'
          parse '.\\*(L\\n(lC'
        when 'iT'
          nr 'aP 0'
          nr 'iD 1'
          parse '.\\*(L\\n(lC'
        end
        if @register['iD'].zero?
          fV
          @register['oM'].value += 1
          nr 'tP 1'
          @register['aP'].value += 1
          parse '.nr tX \\n(C\\n(aP'
          parse '.ds tX \\*(A\\n(aP'
          parse '.ds aA \\*(pA' if @register['nF'] == 1
          if @register["C#{@register['aP']}"] == 1
            parse '.\\*(A\\n(aP'
          else
            @register['aP'].value -= 1
            send :No
          end
          if @register['Xt'] == 1
            parse '.ds xB \\&\\*(L\\n(lC'
          else
            parse '.\\*(L\\n(lC'
          end
        end
        nr 'iD 0'
      else
        parse '.\\*(L\\n(lC'
      end
    end

    #
    # ...
    #

    def tL(*_args)
warn ".#{__callee__} #{_args.inspect}"
      send :lW if @register['tW'] == 0
      lX
      parse '.nr bb \\n(w\\n(\Cu+\\n(lSu'
      parse '.ti -\\n(bbu'
      if @register["w#{@register['lC']}"] < __unesc_pass1('\\w\\*(b1u').to_i
        parse '\\&\\*(b1'
        br
      else
        parse "\\&\\*(b1\\h'|\\n(bbu'\\c"
      end
      #parse '.ds pA \\*(aA' if @register['nF'] == 1 ## and nroff
      @register['oM'].value -= 1
      nr 'tP 0'
      ds 'b1'
      aY
      send :fi, breaking: false
    end

    def lW(*_args)
warn ".#{__callee__} #{_args.inspect}"
      if @named_strings["t#{@register['lC']}"] != 'TagwidtH'
        if @register['tX'] == 1
          parse '.ds t\\n(lN \\*(tX'
          parse '.nr w\\n(lN \\n(\\*(tX'
        else
          parse '.ds t\\n(lN No'
          parse '.nr w\\n(lN \\n(No'
        end
        nr 'tC 1' unless @named_strings["t#{@register['lC']}"] == @named_strings["t#{@register['lN']}"]
      end
    end

    def lX(*_args)
warn ".#{__callee__} #{_args.inspect}"
      if @register['tC'] > 0
        nr 'tC 0'
        nr 'tW 0'
        parse '.sp \\n(dVu' if @register["v#{@register['lC']}"].zero?
        parse '.in \\n(.iu+\\n(w\\n(lCu+\\n(o\\n(lCu+\\n(lSu'
      else
        if @register["v#{@register['lC']}"] == 1
          nr 'aa 0'
        else
          parse '.sp \\n(dVu'
        end
      end
      # ne '2v' unless @register['cR'] > 1
    end

    def lY(*_args)
warn ".#{__callee__} #{_args.inspect}"
      if @register['tC'] > 1
        nr 'tC 0'
        nr 'tW 0'
        parse '.sp \\n(dVu' if @register["v#{@register['lC']}"].zero?
        parse '.in \\n(.iu+\\n(o\\n(lCu'
      else
        if @register["v#{@register['lC']}"] == 1
          nr 'aa 0'
        else
          parse '.sp \\n(dVu'
        end
      end
      # ne '2v' unless @register['cR'] > 1
    end

    # doc-common
    # "not a \-mdoc command: " .LP .PP .pp

    def Dt(*args, heading: nil)
      @named_strings['dT'] = 'UNTITLED'
      @named_strings['vT'] = 'LOCAL'
      @named_strings['cH'] = 'Null'

      @named_strings['dT'] = args[0] if args[0] and !args[0].strip.empty?
      #@manual_entry = args[0]        if args[0] and !args[0].strip.empty?

      if args[1] and !args[1].strip.empty?
        @named_strings['cH'] = args[1]
        @manual_section = args[1]
        @named_strings['vT'] = case args[1].to_i
                               when 1, 6, 7    then @register['sN'] = "#{args[1]}" ; %(System Reference Manual)
                               when 2, 3, 4, 5 then @register['sN'] = "#{args[1]}" ; %(System Programmer's Manual)
                               when 8          then @register['sN'] = "#{args[1]}" ; %(System Manager's Manual)
                               else
                                 case args[1]
                                 when 'unass', 'draft' then 'DRAFT'
                                 when 'paper'          then 'UNTITLED'
                                 end
                              end
      end

      if args[2] and !args[2].strip.empty?
        @named_strings['vT'] = case args[2]
                               when 'USD'   then %(User's Supplementary Documents)
                               when 'PS1'   then %(Programmer's Supplementary Documents)
                               when 'AMD'   then %(Ancestral Manual Documents)
                               when 'SMM'   then %(System Manager's Manual)
                               when 'URM'   then %(System Reference Manual)
                               when 'PRM'   then %(System Programmer's Manual)
                               when 'IND'   then %(Manual Master Index)
                               when 'LOCAL' then %(Local Manual)
                               when 'tahoe' then "#{@named_strings['vT']} (Tahoe Architecture)"
                               when 'vax'   then "#{@named_strings['vT']} (VAX Architecture)"
                               when 'hp300' then "#{@named_strings['vT']} (HP300 Architecture)"
                               end
        @named_strings['vT'] = args[2] if @named_strings['vT'] == 'LOCAL'
      end

      @named_strings[:header] = heading || "#{args[0]}\\^(\\^#{args[1]}\\^)"
      @named_strings[:footer] = "\\*(oS \\- \\*(dD"

      @current_block = blockproto
      @document << @current_block
    end

    def Os(*args)
      @named_strings['oS'] = args[0]
      @named_strings['oS'] = 'BSD Experimental' if args[0].nil? or args[0].strip.empty?
      @named_strings['oS'] = args[1]            if args[1].nil? or args[1].strip.empty?
      @named_strings['oS'] = case args[0]
                             when 'ATT'
                               case args[1]
                               when ''         then 'AT&T\\0UNIX'
                               when '7th', '7' then 'AT&T\\07th Edition'
                               when 'III', '3' then 'AT&T\\0System III'
                               when 'V'        then 'AT&T\\0System V'
                               when 'V.2'      then 'AT&T\\0System V Release 2'
                               when 'V.3'      then 'AT&T\\0System V Release 3'
                               when 'V.4'      then 'AT&T\\0System V Release 4'
                               end
                             when 'BSD'
                               case args[1]
                               when '3'                 then '3rd Berkeley Distribution'
                               when '4'                 then '4th Berkeley Distribution'
                               when '4.1', '4.2', '4.3' then "#{args[1]} Berkeley Distribution"
                               when '4.3T', '4.3t'      then '4.3-Tahoe Berkeley Distribution'
                               when '4.3R', '4.3r'      then '4.3-Reno Berkeley Distribution'
                               when '4.4'               then 'BSD Experimental'
                               end
                             end
    end

    def Dd(*args)
      #@register['gX'] = Register.new(1) unless @named_strings['dD'].empty?
      @named_strings['dD'] = 'Epoch'
      return unless args.any?
      @named_strings['dD'] = if args.length == 3
                               "#{args[0]} #{args[1]} #{args[2]}"
                             else
                               "#{ %w[January February March April May June July
                                      August September October November December]
                                  [@register['mo'] - 1] } #{@register['dy']}, 19#{@register['yr']}"
                             end
    end

=begin
    def hM
    end

    def fM
    end

    def lM
    end
=end

    # doesn't reset font/indent
    def Pp(*_args)
      @current_block = blockproto
      @document << @current_block
    end

    alias :Lp :Pp

    def Nd(*args)
warn ".#{__callee__} #{args.inspect}"
      parse "\\&\\-\\& #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
    end

=begin
    def Ss
    end

    def Rd
    end
=end
    # doc-ditroff

    def pL(*_args)
warn ".#{__callee__} #{_args.inspect}"
      @register['Hm'] = Register.new(to_u('.5i'))
      @register['Fm'] = Register.new(to_u('.5i'))
      @register['ll'] = Register.new(to_u('6.5i'))
      #ll('6.5i')
      @register['lt'] = Register.new(to_u('6.5i'))
      #lt('6.5i')
      @register['po'] = Register.new(to_u('1i'))
      #po('1.i')
      @register['dV'] = Register.new(to_u('.5v'))
    end

    def hK(*_args)
warn ".#{__callee__} #{_args.inspect}"
      ds 'hT \\*(dT'
      if (@named_strings['cH'] != 'Null')
        if (@named_strings['gP'] != 'Null')
          parse '.as hT \\|(\\|\\*(cH\\*(gP\\|)'
        else
          parse '.as hT \\|(\\|\\*(cH\\|)'
        end
      end
      if (@named_strings['cH'] == 'Null')
        parse '.as hT \\&\\|*\\|\\*(gP\\|)' unless @named_strings['gP'] == 'Null'
      end
      wh '0 hM'
      wh '-1.25i fM'
      parse '.nr nL \\n(nl'
      if (@register['gX'] == 1)
        rm 'n1'
        #bp
      #else
        #bp(breaking: false)
      end
      if (@register['nL'] > 0)
        nr '% 1' if (@register['nC'] <= 0)
      end
      nr 'gX 0'
      em 'lM'
    end

    def sW(*args)
warn ".#{__callee__} #{args.inspect}"
      parse ".nr sW \\w\\fC#{args[0]}"
      if @register['sW'] >= @register['fW'].value
        if @register['sW'].value % @register['fW'].value > 0
          parse '.nr sW (\\n(sW/\\n(fW)+1'
        else
          parse '.nr sW \\n(sW/\\n(fW'
        end
      else
        if @register['sW'] > 0
          nr 'sW 1'
        else
          nr 'sW 0'
        end
      end
    end

    def aW(*args)
warn ".#{__callee__} #{args.inspect} // #{@named_strings["A#{args[0]}"].inspect}"
      #parse ".nr sW \\w\\fC\\*(A#{args[0]}" # REVIEW how can this not be causing loss of \fP
      parse ".nr sW \\w\\fC\\*(A#{args[0]}\\fP"
      if @register['sW'] >= @register['fW'].value
        if @register['sW'].value % @register['fW'].value > 0
          parse '.nr sW (\\n(sW/\\n(fW)+1'
        else
          parse '.nr sW \\n(sW/\\n(fW'
        end
      else
        if @register['sW'] > 0
          nr 'sW 1'
        else
          nr 'sW 0'
        end
      end
    end

    #def Ql
    #end

    def Sh(*args)
warn ".#{__callee__} #{args.inspect}"
      xinit_in
      @register['nS'] = Register.new(0)
      @register['sE'] = Register.new(0)
      @register['iS'] = Register.new(0)
      #ad(breaking: false)
      if (args[0] == 'NAME')
        hK
        #send(:in, '0', breaking: false)
      else
        @register['nS'] = Register.new(0)
        @register['nA'] = Register.new(0)
        @register['nF'] = Register.new(0)
        @register['nT'] = Register.new(0)
        @register['nY'] = Register.new(0)
        @register['oT'] = Register.new(0)
        case args[0]
        when 'SYNOPSIS'
          #na
          @register['nS'].value = 1
        when 'DESCRIPTION'
          @register['fY'] = Register.new(0)
          @register['fZ'] = Register.new(0)
          @register['fB'] = Register.new(0)
          @register['Fb'] = Register.new(0)
          @named_strings['Fb'] = String.new
        when 'SEE'
          @register['nA'].value = 1
          #na
          @register['sE'].value = 1
        when 'FILES'     then @register['nF'].value = 1
        when 'STANDARDS' then @register['nT'].value = 1
        when 'AUTHORS'   then @register['nY'].value = 1
        end
        #send(:in, '0')
        @register['aN'] = Register.new(0)
      end
      #pL
      #sp(breaking: false)
      #ns
      ta '.5i 1i 1.5i 2i 2.5i 3i 3.5i 4i 4.5i 5i 5.5i 6i 6.5i'
      #parse '.if !\\n(cR .ne 3'
      fi(breaking: false)

      #parse "\\&\\*(sH#{args[0]} \\|#{args[1]} \\|#{args[2]} \\|#{args[3]} \\|#{args[4]} \\|#{args[5]} \\|#{args[6]} \\|#{args[7]} \\|#{args[8]}"
      #parse '\\&\\fP\\s0\\&'

      @current_block = blockproto Block::Head
      @document << @current_block
      unescape(args.join(' '))
      @section_heading = @current_block.to_s
      #parse "\\&\\fP\\s#{Font.defaultsize}\\&"

      #parse '.in \\n(.iu+\\n(Tiu'
      #ns
      send :Pp
    end

    # doc-syms

    def Ux(*args)
warn ".#{__callee__} #{args.inspect}"
      @register['cF'] = @register['.f'].dup
      @register['cZ'] = @register['.s'].dup
      @named_strings['aa'] = '\\&\\f\\n(cF\\s\\n(cZ'
      parse '.as b1 \\&\\*(tNUNIX\\*(aa'
      rm 'aa'
      parse ".aV #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}" if @register['aC'].zero? and args.any?
      if (@register['aC'] > @register['aP'].value)
        @register['aP'].value += 1
        if (@register["C#{@register['aP']}"] == 1)
          parse '\\*(A\\n(aP'
        else
          nR
        end
      else
        aZ
      end
    end

    def Bx(*args)
warn ".#{__callee__} #{args.inspect}"
      @register['cF'] = @register['.f'].dup
      @register['cZ'] = @register['.s'].dup
      @named_strings['aa'] = '\\&\\f\\n(cF\\s\\n(cZ'
      if @register['aC'].zero?
        if args.empty?
          parse '\\&\\*(tNBSD\\*(aa \\*(tNUNIX\\*(aa'
        else
          parse ".aV #{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]} #{args[6]} #{args[7]} #{args[8]}"
        end
      end
      case args[0]
      when '-alpha'
        parse '\\&currently in alpha test.'
        aY
      when '-beta'
        parse '\\&currently in beta test.'
        aY
      when '-devel'
        parse '\\&currently under development.'
        aY
      end
      if (@register['aC'] > @register['aP'].value)
        @register['aP'].value += 1
        if (@register["C#{@register['aP']}"] == 2)
          as 'b1 \\&\\*(A\\n(aP\\&\\*(tNBSD\\*(aa'
          if (@register['aC'] > @register['aP'].value)
            @register['jj'] = @register['aP'].value + 1
            if (@register["C#{@register['jj']}"] == 2)
              case @named_strings["A#{@register['jj']}"]
              when 'Reno', 'reno'
                @register['aP'].value += 1
                parse '.as b1 \\&\\-Reno'
              when 'Tahoe', 'tahoe'
                @register['aP'].value += 1
                parse '.as b1 \\&\\-Tahoe'
              else
                if (@register['aC'].value > @register['aP'])
                  @register['aP'].value += 1
                  nR
                else
                  aZ
                end
              end
            else
              @register['aP'].value += 1
              nR
            end
          end
          rr('jj')
        else
          aZ
        end
      else
        parse '.as b1 \\&\\*(tNBSD\\*(aa U\\*(tNNUX\\*(aa' # REVIEW sic
        nR
      end
    end

    def Ud(*_args)
warn ".#{__callee__} #{_args.inspect}"
      parse '\\&currently under development.'
    end

    def At(*args)
warn ".#{__callee__} #{args.inspect}"
      @register['cF'] = @register['.f'].dup
      @register['cZ'] = @register['.s'].dup
      parse '.ds aa \\&\\f\\n(cF\\s\\n(cZ'
      case args.length
      when 1
        case args[0]
        when '32v' then parse "\\&Version 32V \\*(tNAT&T UNIX\\*(aa#{args[1]}"
        when 'v6'  then parse "\\&Version 6 \\*(tNAT&T UNIX\\*(aa#{args[1]}"
        when 'v7'  then parse "\\&Version 7 \\*(tNAT&T UNIX\\*(aa#{args[1]}"
        when 'V'   then parse "\\&\\*(tNAT&T UNIX\\*(aa System V \\*(tNUNIX\\*(aa#{args[1]}"
        when 'V.1' then parse "\\&\\*(tNAT&T UNIX\\*(aa System V.1 \\*(tNUNIX\\*(aa#{args[1]}"
        when 'V.4' then parse "\\&\\*(tNAT&T UNIX\\*(aa System V.4 \\*(tNUNIX\\*(aa#{args[1]}"
        end
      when 2
        case args[0]
        when '32v' then parse "\\&Version 32V \\*(tNAT&T UNIX\\*(aa"
        when 'v6'  then parse "\\&Version 6 \\*(tNAT&T UNIX\\*(aa"
        when 'v7'  then parse "\\&Version 7 \\*(tNAT&T UNIX\\*(aa"
        when 'V'   then parse "\\&\\*(tNAT&T UNIX\\*(aa System V \\*(tNUNIX\\*(aa"
        when 'V.1' then parse "\\&\\*(tNAT&T UNIX\\*(aa System V.1 \\*(tNUNIX\\*(aa"
        when 'V.4' then parse "\\&\\*(tNAT&T UNIX\\*(aa System V.4 \\*(tNUNIX\\*(aa"
        end
      end
    end

    def Bt(*_args)
warn ".#{__callee__} #{_args.inspect}"
      parse '\\&currently in beta test.'
    end

    #def St
    #end

  end
end
