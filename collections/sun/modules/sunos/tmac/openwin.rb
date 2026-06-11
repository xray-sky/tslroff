# frozen_string_literal: true
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
#   .so man3/macros.x (where?)
#   use of \f4 e.g. resources(3) - nothing mounted. what is it? _not_ symbol.
#   \*(oL def (where?)
#   reconcile OpenWindows/Xt conflicting defs of e.g. .FN, .TH ?? ("MIT Stuff"?)
#    - TH might be integratable based on section
#    - or separate. some macro names are the same.
#      ...but, we don't know 3W vs 3Xt from filename
#   .XR (diagram crossref)
#   .CP PSART/foo.ps (postscript include - diagrams)
#

module SunOS
  module Macros
    module OpenWindows

      def self.extended(k)
        k.send :nr, '"o 1' # prevent multiple inclusion
        k.send :nr, 'Ji 16'
      end

      # makes use of .# which we are spending a lot of time logging the rejection of
      define_method '#' do |*_args| ; end

      # redefines .R, .B, .I, plus .L and .LB
      def B(*args)
        nr "PQ #{@register['.f']}"
        ft '3'
        parse "\\&\\f#{@register['PQ']}#{args[2]}\\fI#{args[0]}\\f#{@register['PQ']}#{args[1]}" if args[0] and !args[0].empty?
      end

      def I(*args)
        nr "PQ #{@register['.f']}"
        ft '2'
        parse "\\&\\f#{@register['PQ']}#{args[2]}\\fI#{args[0]}\\|\\f#{@register['PQ']}#{args[1]}" if args[0] and !args[0].empty?
      end

      def L(*args) # REVIEW "listing font"
        nr "PQ #{@register['.f']}"
        parse "\\&\\f#{@register['PQ']}#{args[2]}\\fL#{args[0]}\\f#{@register['PQ']}#{args[1]}" if args[0] and !args[0].empty?
      end

      def LB(*args) # REVIEW "bold listing font"
        nr "PQ #{@register['.f']}"
        parse "\\&\\f#{@register['PQ']}#{args[2]}\\fLB#{args[0]}\\f#{@register['PQ']}#{args[1]}" if args[0] and !args[0].empty?
      end

  ### "MIT Stuff"

      def Jn(*args)
        parse "#{args[0]}\\fL\\^#{args[1]}\\^\\fR#{args[2]}"
      end

      def JN(*args)
        parse "\\fL\\^#{args[0]}\\^\\fR#{args[2]}"
      end

      # this def in XtPopdown(3) is paired with an FN that is different from the one I found elsewhere
      def FD(*_args)
        send :LP
        send :KS # def?
        send :TA, '.5i 3i' # def?
        ta '.5i 3i'
        nf
      end

      def NT(*args)
        #ne '7'
        ds 'NO Note'
        ds "NO #{args[1]}" if args.length > args[0].to_i and args[1] != 'C'
        ds "NO #{args[0]}" if args.length > 0 and args[0] != 'C'
        sp '10p'
        send :TB
        ce
        parse "\\*(NO"
        sp '5p'
        ce '99' if args[0] == 'C' or args[1] == 'C'
        send :in, '+5n'
        #ll '-5n'
        send :R
      end

      def NE(*_args)
        ce '0'
        send :in, '-5n'
        #ll +5n'
        sp '10p'
      end

      define_method 'C{' do |*_args|
        warn "don't know .C{ #{_args}"
        send :KS # def?
        nf
        send :D # def?
        ft 'CW'
        # ps "#{@register['PS']}"
        # vs "#{@register['VS']}u"
      end

      define_method '}C' do |*_args|
        warn "don't know .}C #{_args}"
        send :DE
        send :R
      end

  ### end "MIT Stuff"

      def Jo(*args)
        hold = @current_block
        @current_block = blockproto(Block::Boxed)

        parse "#{args[0]}\\h'2.0i-\\w'#{args[0]}'u'#{args[1]}\\h'1.5i-\\w'#{args[1]}'u'#{args[2]}\\h'1.5i-\\w'#{args[2]}'u'#{args[3]}"

        hold << @current_block
        @current_block = hold
      end

      # 5.1 gives two consecutive non-equivalent defs for .Jp - this is the second
      def Jp(*args)
        hold = @current_block
        @current_block = blockproto(Block::Boxed)

        parse " \\fIclass\\fP:\\0\\&\\fL\\#{args[0]}\\fP\\h'1.5i-\\w'\\fL#{args[0]}\\fP'u'\\fItype\\fP:\\0\\&\\fL#{args[1]}\\fP\\h'1.25i-\\w'\\fL#{args[1]}\\fP'u'\\fIdefault\\fP:\\0\\&\\fL#{args[2]}\\fP\\h'1.0i-w'\\fL#{args[2]}\\fP'u'\\h'|5i'\\fIaccess\\fP:\\0\\&\\fL#{args[3]}\\fP\\h'1.0i-\w'\\fL#{args[3]}\\fP'u'"

        hold << @current_block
        @current_block = hold
      end

      def Jq(*args)
        hold = @current_block
        @current_block = blockproto(Block::Boxed)

        parse ".nr jw \\w'\\fL#{args[0]}\\fP'"
        parse ".nr jw \\n(jw+\\w'\\fL#{args[1]}\\fP'"
        parse ".nr jw \\n(jw+\\w'\\fL#{args[2]}\\fP'"
        br
        if @register['jw'] > 1300 # REVIEW ought this be scaled to our default units?
          parse "\\fIclass\\fP:\\|\\&\\fL#{args[0]}\\0\\fItype\\fP:\\|\\&\\fL#{args[1]}\\0\\fIdefault\\fP:\\|\\&\\fL#{args[2]}\\fP\\h'|4.9i'\\fIaccess\\fP:\\|\\|\\&\\fL#{args[3]}\\fP\\h'0.8i-\\w'\\fL#{args[3]}\\fP'u'"
        else
          parse "\\fIclass\\fP:\\|\\&\\fL#{args[0]}\\fP\\h'1.5i-\\w'\\fL#{args[0]}\\fP'u'\\fItype\\fP:\\|\\&\\fL#{args[1]}\\fP\\h'1.25i-\\w'\\fL#{args[1]}\\fP'u'\\fIdefault\\fP:\\|\\&\\fL#{args[2]}\\fP\\h'1.0i-\\w'\\fL#{args[2]}\\fP'u'\\h'|5i'\\fIaccess\\fP:\\|\\&\\fL#{args[3]}\\fP\\h'0.8i-\\w'\\fL#{args[3]}\\fP'u'"
        end

        hold << @current_block
        @current_block = hold
      end

      def JF(*args)
        parse ".nr Jf \\w'\\*(Jf'"
        parse ".nr Jf \\w'#{args[2]}'" if args[2] and !args[2].empty?
        parse "#{args[0]} \\h'.25i+\\n(Jfu-\\w'#{args[0]}'u'#{args[1]}"
        br
      end

      def Lx(*args)
        parse %(.L "#{args[0]}" "#{args[1]}" "#{args[2]}")
        #.IX "\\$1" "" "\fL\\$1\f1"
      end

      def Ix(*args)
        parse %(.I "#{args[0]}" "#{args[1]}" "#{args[2]}")
        #.IX "\\$1" "" "\fL\\$1\f1"
      end

      def Bx(*args)
        parse %(.B "#{args[0]}" "#{args[1]}" "#{args[2]}")
        #.IX "\\$1" "" "\fL\\$1\f1"
      end

      def Jx(*args)
        parse %(.Lx "#{args[0]}" "#{args[1]}" "#{args[2]}")
      end

      alias :JX :Jx

      def JL(*args)
        if args.empty?
          ft 'L'
        else
          parse %(.L "#{args[0]}" "#{args[1]}" "#{args[2]}")
        end
      end

      def JR(*_args)
        ft '1'
      end

      def JS(*_args)
        parse '.JL'
        nf
      end

      def JE(*_args)
        parse '.JR'
        fi
      end

      def TF(*args)
        nr "TF #{@register['.f']}"
        nr "TX #{@register['.s']}"
        nr 'PL 3'
        # two pointless conditions involving \n(PL=1 or 2 elided
        #ta '2iR 2.25i' # is this a right justified tab? or just an error
        ta '2i 2.25i'
        ti '0'
        parse "\t\\&\\s11\\0\\0#{@named_strings['tS']}\t\\fI\\&#{args[0]}\\f#{@register['TF']}\\s#{@register['TX']}"
      end

      def TN(*args)
        nr 'T1 +1'
        ll "#{@register['LL']}u"
        ds "tH #{args[0]}"
        ds "tS Table #{@register['T1']}"
        if @register['IK'] <= 0
          sp '1v' if @register['nl'] > @register['L#'].value # careful comparing Registers
          sp "|@#{register['B#']}u+2v" if @register['B#'] > 0 and @register['B#'] >= @register['nl'].value
          nr 'B# 0'
        else
          sp '1v'
          if @register['K#'] > 0
            sp "|#{@register['K#']}u+2v"
            nr 'K# 0'
          else
            sp "(#{@register['B#']}u-#{@register['nl']}u+1v)u" if @register['B#'] >= @register['nl'].value
            nr 'B# 0'
          end
        end
        ne '2i'
        parse %(.TF "#{@named_strings['tH']}")
        #.if \\nF .if \\n(IK \!.tm .CE F 1 "\\$1" \\\\n% \\n(H1 \\n(T1
        #.if \\nF .if !\\n(IK .tm .CE F 1 "\\$1" \\n% \\n(H1 \\n(T1
      end

      def TC(*_args) ; end # table continued on next page - who cares

      def FN(*args)
        nr 'F1 +1'
        ll "#{@register['LL']}u"
        ds "tS Figure #{@register['F1']}"
        sp '1v'
        parse %(.TF "#{args[0]}")
        #.if \\nF .if \\n(IK \!.tm .CE F 1 "\\$1" \\\\n% \\n(H1 \\n(F1
        #.if \\nF .if !\\n(IK .tm .CE F 1 "\\$1" \\n% \\n(H1 \\n(F1
      end

      def TH(*args)
        send :PD
        send :DT
        nr 'F1 0'
        ll '7i'
        nr "LL #{@register['.l']}"
        ds "]H #{args[0]}\\|(\\|#{args[1]}\\|)"
        ds ']D Misc. Reference Manual Pages'
        ds ']D OPEN LOOK Widgets' if args[1] == '3W'
        ds ']D Xt Intrinsics' if args[1] == '3Xt' # "MIT Stuff"
        ds "]W #{args[3]}" if args[3] and !args[3].empty?
        ds "]D #{args[4]}" if args[4] and !args[4].empty? # pointless?
        ds ']D 3W'
        wh '0 }H'
        wh '-.8i }F'
        em '}M'
        nr 'P 1' unless @register['nl'] > 0 and @register['P'] > 0
        pn "#{@register['P']}" unless @register['nl'] > 0 and @register['P'] > 0
        if @register['A'] > 0 and @register['P'] >= @register['A'].value
          ds "PN #{@register['P']}"
          pn '1'
          af '% a'
          nr 'A 0'
        end
        nr 'P 0' if @register['nl'] <= 0 and @register['P'] > 0
        #.if  \\nC .if \\n(nl .bp
        #.if  !\\nC .if \\n(nl .bp 1
        ds "]L modified #{args[2]}"
        nr "]L #{args[2]}"
        rm ']L' if @register[']L'] == 0 # wtf are you guys even doing

        @named_strings[:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @named_strings[']L'].empty?
        heading = "#{args[0]}\\|(\\|#{args[1]}\\|)\\0\\0\\(em\\0\\0\\*(]D"
        super(*args, heading: heading)

        parse '.}E'
        parse '.DT'
        nr ')I .5i'
        nr ')R 1i'
        #mk 'ka'
        #.if !'\\n(ka'-1' .bp
        #.if \\nF .tm .CE MAN-PAGE 1 \\$1(\\$2) \\n%
        #.ev 1
        #.if n .tl \\*(]W\\*(]D\\*(]H
        #.ev
      end

    end
  end
end
