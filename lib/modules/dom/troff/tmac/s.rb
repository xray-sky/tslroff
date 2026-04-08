# frozen_string_literal: true
#
# tmac.s
#
#   usrdoc (mit afs), others
#   these are not all the same. surprise! check how they differ maybe.
#   this one from 4.3_VAX_MIT
#
# TODO
#   ...everything!
#

class Troff
  module Macros
    module S

      def RT(*_args) # reset everything to normal state
        send :BG if @register['1T'] <= 0
        ce '0'
        di if @register['IK'] <= 0 and @register['IF'] <= 0 and @register['IX'] <= 0 and @register['BE'] <= 0
        ul '0'
        if @register['QP'] > 0
          ll '+\n(QIu'
          send :in, '-\n(QIu'
          nr 'QP -1'
        end
        ll '\n(LLu' if @register['NX'] <= 1 and @register['AJ'].zero?
        if @register['IF'].zero?
          ps '\n(PS'
          vs '\n(VSu' if @register['VS'] >= 41
          vs '\n(VSp' if @register['VS'] <= 40
        end
        send :in, '\n(I\n(IRu' if @register['IP'] > 0
        if @register['IP'].zero? and @register['IR'].zero?
          nr 'I1 \n(PIu'
          %w[I2 I3 I4 I5 J0 J1 J2 J3 J4 J5].each { |r| req_nr "#{r} 0" }
        end
        nr 'IP -1' if @register['IP'] > 0
        ft 1
        bd 1
        ta '5n 10n 15n 20n 25n 30n 35n 40n 45n 50n 55n 60n 65n 70n 75n 80n'
        fi
      end

      def IZ(*_args) # initialization
        nr 'TN 0'
        em 'EM'
        # REVIEW are HTML entities safe through \* ?? - this might take rewrites (\*'e or \*`e to get é or è)
        #ds %(' ) # non-spacing acute accent
        #ds %(` ) # non-spacing grave accent
        #ds ': ' # non-spacing umlaut
        #ds '^ ' # non-spacing circumflex
        #ds '~ ' # non-spacing tilde accent
        #ds 'C ' # non-spacing hacek (majuscule - case immaterial for html)
        #ds 'v ' # non-spacing hacek (minuscule - case immaterial for html)
        #ds ', ' # non-spacing cedilla
        # TODO some non-.de stuff from tmac.srefs
        ds %([. \\s-2\\v'-.4m'\\f1)
        ds %(.] \\v'.4m'\\s+2\\fP)
        ds %([o ``)
        ds %([c '')
        ch 'FO \n(YYu'
        nr 'FM 1i' if @register['FM'].zero?
        nr 'YY -\n(FMu'
        nr 'XX 0 1'
        nr 'IP 0'
        nr 'PI 5n'
        nr 'DV .5v'
        nr 'QI 5n'
        nr 'I0 \n(PIu'
        nr 'PS 10'
        nr 'VS 12'
        nr 'PD 0.3v' if @register['PD'] <= 0
        nr 'ML 3v'
        ps '\n(PS'
        vs '\n(VSu' if @register['VS'] >= 41
        vs '\n(VSp' if @register['VS'] <= 40
        nr 'IR 0'
        nr 'I0 0'
        nr 'I1 \n(PIu'
        nr 'TB 0'
        nr 'SJ \n(.j'
        nr 'LL 6i'
        ll '\n(LLu'
        nr 'LT \n(.l'
        lt '\n(LTu'
        ev '1'
        nr 'FL \n(LLu*11u/12u'
        ll '\n(FLu'
        ps '8'
        vs '10p'
        ev
        parse '.if \000\*(CH\000\000 .ds CH "\(hy \\n(PN \(hy'
        wh '0 NP'
        wh '-\n(FMu FO'
        ch 'FO 16i'
        wh '-\n(FMu FX'
        ch %{FO '-\n(FMu}
        wh '-\n(FMu/2u BT'
        nr 'CW 0-1'
        nr 'GW 0-1'
      end

      def TM(*args)
        pn '0' if @regster['IM'] == 0 and @register['MN'] == 0
        #.so /usr/lib/tmac/tmac.scover
        if @regster['IM'] == 0 and @register['MN'] == 0
          rm 'IM'
          rm 'MF'
          rm 'MR'
        end
        #.if \\n(.T=0 .pi /usr/bin/col
        nr 'ST 1'
        ds 'QF MEMORANDUM FOR FILE'
        br
        ds "MN #{args[0]}"
        nr 'MM 1' if args[0] and !args[0].empty?
        nr 'MC 1' if args[1] and !args[1].empty?
        nr 'MG 1' if args[2] and !args[2].empty?
        nr 'TN 1'
        ds "CA #{args[1]}" if args[1]
        ds "CC #{args[2]}" if args[2]
        rm 'RP'
        rm 'S0'
        rm 'S2'
        rm 'AX'
      end

      def IM(*args) # internal memorandum
        nr 'IM 1'
        parse %(.TM "#{args[0]}" "#{args[1]}" "#{args[2]}")
        rm 'QF'
        parse '.RA'
        rm 'RA'
        rm 'RP'
        rm 'MF'
        rm 'MR'
      end

      def MF(*args) # memorandum for file.
        nr 'MN 1'
        parse %(.TM "#{args[0]}" "#{args[1]}" "#{args[2]}")
        rm 'MR'
        rm 'IM'
        parse '.RA'
        rm 'RA'
        rm 'RP'
        rm 'TM'
      end

      def MR(*args) # memo for record
        nr 'MN 2'
        parse %(.TM "#{args[0]}" "#{args[1]}" "#{args[2]}")
        rm 'MF'
        parse '.RA'
        rm 'RA'
        rm 'RP'
        rm 'IM'
        rm 'TM'
      end

      def EG(*args)
        nr 'MN 3'
        parse %(.TM "#{args[0]}" "#{args[1]}" "#{args[2]}")
        ds 'QF ENGINEER\'S NOTES'
        rm 'MF'
        rm 'RP'
        rm 'IM'
        parse '.RA'
        rm 'RA'
        rm 'TM'
      end

      def LT(*_args) # Letter
        parse '.LP'
        rs
        sp '6'
        ll '80n'
        ti '48'
        parse '\\*(DY'
        ll
        br
        sp '3'
      end

      def OK(*_args)
        br
        di
        di 'OD'
      end

      def RP(*_args)
        nr 'ST 2'
        pn '0'
        rm 'SG'
        rm 'CS'
        rm 'TM'
        rm 'QF'
        rm 'IM'
        rm 'MR'
        rm 'MF'
        rm 'EG'
      end

      def TR(*args)  # Comp. Sci. Tech Rept series.
        nr 'ST 3'
        pn '0'
        ds "MN #{args[0]}"
        rm 'SG'
        rm 'CS'
        rm 'TM'
        rm 'QF'
        rm 'IM'
        rm 'MR'
        rm 'MF'
        rm 'EG'
        br
      end

      def TL(*_args) # title and initialization
        br
        nr 'TV 1'
        rm 'CS' if @register['IM'] > 0 or @register['MN'] > 0
        parse '.ME'
        rm 'ME'
        di 'WT'
        nr "SJ #{@register['.j']}"
        na
        fi
        ll(@register['TN'] > 0 ? '3.5i' : '5.0i')
        ft '3'
        ps(@register['TN'] > 0 ? '10' : '12')
        rm 'CS' unless @register['TN'] > 0
        hy '0'
      end

      def TX(*args)
        rs
        sp '.5i'
        ce '1000'
        ps '12'
        ft '3'
        vs '15p'
        ne '4'
        hy '0'
        parse '.WT'
        hy '14'
        ce '0'
        ul '0'
      end

      def AU(*args) # author(s)
        nr 'AV 1'
        ad "#{@register['SJ']}"
        br
        di
        br
        nf
        nr 'NA +1'
        ds "R#{@register['NA']} #{args[0]}"
        ds "E#{@register['NA']} #{args[1]}"
        di "A#{@register['NA']}"
        ll "#{@register['LL']}u"
        ft '2' if @register['TN'] == 0
        ft '3' if @register['TN'] > 0
        ll '1.4i' if @register['TN'] > 0
        ps '10'
      end

      def AX(*args)
      end

      def AI(*args) # authors institution
      end

      def AB(*args) # begin an abstract
      end

      def AE(*args) # end of an abstract
      end

      def SY(*args) # cover sheet of released paper
      end

      def S2(*args) # first text page, released paper format
      end

      def S0(*args) # mike lesk conserve paper style
      end

      def S3(*args) # CSTR style
      end

      def SG(*args) # signature
      end

      def TS(*args) # Tables.  TS - table start, TE - table end
      end

      def TQ(*args)
      end

      def TH(*args)
      end

      def TE(*args)
      end

      def EQ(*args)  #equation, breakout and display
      end

      def EN(*args)  # end of a displayed equation
      end

      def PS(*args)	# start picture (bwk)
      end

      def PE(*args)	# end of picture
      end

      def ME(*args)
      end

      def EM(*args) # end up macro - process left over keep-release
      end

      def NP(*args) # new page
      end

      def XK(*args)
      end

      def KD(*args)
      end

      def PT(*args)
      end

      def FO(*args) # footer of page
      end

      define_method '2C' do |*args| # begin double column
      end

      def MC(*args) # multiple columns- arg is line length
      end

      def RC(*args)
      end

      def C1(*args)
      end

      def C2(*args)
      end

      define_method '1C' do |*args| # return to single column format
      end

      def MH(*args)
      end

      def PY(*args)
      end

      def BT(*args)
      end

      def PP(*args) # paragraph
      end

      def SH(*args) # (unnumbered) section heading
      end

      def NH(*args) # numbered heading
      end

      def BG(*args) # begin, execute at first PP
      end

      def TL(*args)
      end

      def AU(*args)
      end

      def AI(*args)
      end

      def RA(*args) #redefine abstract macros
      end

      def AB(*args)
      end

      def AE(*args)
      end

      def IP(*args) # indented paragraph
      end

      def LP(*args) # left aligned (block) paragraph
      end

      def QP(*args)
      end

      def IE(*args) # synonym for .LP
      end

      def XP(*args)
      end

      def RS(*args) # prepare for double indenting
      end

      def RE(*args) # retreat to the left
      end

      def TC(*args)
      end

      def TD(*args)
      end

      def CM(*args) # cut mark
      end

      def B(*args) # bold font
      end

      def BI(*args)	# bold italic -- only on 202
      end

      def R(*args) # Roman font
      end

      def I(*args) # italic font
      end

      def TA(*args) # tabs set in ens or chars
        ta(args.join('n ') + 'n')
      end

      def SM(*args) # make smaller size
    #.if \\n(.$>0 \&\\$3\s-2\\$1\s0\\$2
    #.if \\n(.$=0 .ps -2
      end

      def LG(*args) # make larger size
        ps '+2'
      end

      def NL(*args) # return to normal size
        ps '\\n(PS'
      end

      def DA(*args) # force date; ND - no date or new date.
    #.if \\n(.$ .ds DY \\$1 \\$2 \\$3 \\$4
    #.ds CF \\*(DY
      end

      def ND(*args)
    #.ME
    #.rm ME
    #.ds DY \\$1 \\$2 \\$3 \\$4
    #.rm CF
      end

      def FN(*args) # footnote end
        send 'FS'
      end

      def FJ(*args)
    #'ce 0
    #.nr IA \\n(IP
    #.nr IB \\n(.i
    #.ev1
    #.ll \\n(FLu
    #.da FF
    #.br
    #.if \\n(IF>0 .tm Footnote within footnote-illegal.
    #.if \\n(IF>0 .ab
    #.nr IF 1
    #.if !\\n+(XX-1 .FA
      end

      def FK(*args)
    #.br
    #.in 0
    #.nr IF 0
    #.di
    #.ev
    #.if !\\n(XX-1 .nr dn +\\n(.v
    #.nr YY -\\n(dn
    #.if \\n(NX=0 .nr WF 1
    #.if \\n(dl>\\n(CW .nr WF 1
    #.if (\\n(nl+\\n(.v)<=(\\n(.p+\\n(YY) .ch FO \\n(YYu
    #.if (\\n(nl+\\n(.v)>(\\n(.p+\\n(YY) .if \\n(nl>(\\n(HM+1.5v) .ch FO \\n(nlu+\\n(.vu
    #.if (\\n(nl+\\n(.v)>(\\n(.p+\\n(YY) .if \\n(nl+\\n(FM+1v>\\n(.p .ch FX \\n(.pu-\\n(FMu+2v
    #.if (\\n(nl+\\n(.v)>(\\n(.p+\\n(YY) .if \\n(nl<=(\\n(HM+1.5v) .ch FO \\n(HMu+(4u*\\n(.vu)
    #.nr IP \\n(IA
    #'in \\n(IBu
      end

      def FS(*args) # First page footer
    #.ev1
    #.br
    #.ll \\n(FLu
    #.da FG
      end

      def FE(*args)
    #.br
    #.di
    #.nr FP \\n(dn
    #.if \\n(1T=0 .nr KG 1 \"not in abstract repeat next page.
    #.if "\\n(.z"OD" .nr KG 0 \" if in OK, don't repeat.
    #.ev
      end

      def FA(*args)
    #.if t \l'1i'
    #.br
      end

      def FV(*args)
    #.FS
    #.nf
    #.ls 1
    #.FY
    #.ls
    #.fi
    #.FE
      end

      def FX(*args)
    #.if \\n(XX>0 .di FY
    #.if \\n(XX>0 .ns
      end

      def XF(*args)
    #.if \\n(nlu+1v>(\\n(.pu-\\n(FMu) .ch FX \\n(nlu+1.9v
    #.ev1
    #.nf
    #.ls 1
    #.FF
    #.rm FF
    #.nr XX 0 1
    #.br
    #.ls
    #.di
    #.fi
    #.ev
      end

      def FL(*args)
    #.ev1
    #.nr FL \\$1n
    #.ll \\$1
    #.ev
      end

      def HO(*args)
        parse 'Bell Laboratories'
        parse 'Holmdel, New Jersey 07733'
      end

      def WH(*args)
        parse 'Bell Laboratories'
        parse 'Whippany, New Jersey 07981'
      end

      def IH(*args)
        parse 'Bell Laboratories'
        parse 'Naperville, Illinois 60540'
      end

      def UL(*args) # underline argument, don't italicize
    #.if t \\$1\l'|0\(ul'\\$2
      end

      def UX(*args)
    #.ie \\n(GA>0 \\$2\s-1UNIX\s0\\$1
    #.el \{\
    #.if n \\$2UNIX\\$1*
    #.if t \\$2\s-1UNIX\\s0\\$1\\f1\(dg\\fP
    #.FS
    #.if n * UNIX
    #.if t \(dg UNIX
    #.ie \\$3=1 is a Footnote of Bell Laboratories.
    #.el is a Trademark of Bell Laboratories.
    #.FE
    #.nr GA 1\}
      end

      def US(*args)
        parse 'the'
        send :UX
        parse 'operating system'
      end

      def QS(*args)
        br
        send :LP
        send :in, '+\\n(QIu'
      end

      def QE(*args)
        br
        send :in, '-\\n(QIu'
        send :LP
      end

      def B1(*args) # begin boxed stuff
    #.br
    #.di BB
    #.nr BC 0
    #.if "\\$1"C" .nr BC 1
    #.nr BE 1
      end

      def B2(*args) # end boxed stuff
    #.br
    #.nr BI 1n
    #.if \\n(.$>0 .nr BI \\$1n
    #.di
    #.nr BE 0
    #.nr BW \\n(dl
    #.nr BH \\n(dn
    #.ne \\n(BHu+\\n(.Vu
    #.nr BQ \\n(.j
    #.nf
    #.ti 0
    #.if \\n(BC>0 .in +(\\n(.lu-\\n(BWu)/2u
    #.in +\\n(BIu
    #.ls 1
    #.BB
    #.ls
    #.in -\\n(BIu
    #.nr BW +2*\\n(BI
    #.sp -1
    #\l'\\n(BWu\(ul'\L'-\\n(BHu'\l'|0\(ul'\h'|0'\L'\\n(BHu'
    #.if \\n(BC>0 .in -(\\n(.lu-\\n(BWu)/2u
    #.if \\n(BQ .fi
    #.br
      end

      def AT(*args)
        nf
        sp
        parse 'Attached:'
      end

      def CT(*args)
        nf
        sp
        parse args.any? ? "Copy to #{args[0]}:" : 'Copy to:'
      end

      def BX(*args)
        parse "\\(br\\|#{args[0]}\\|\\(br\\l'|0\\(rn'\\l'|0\\(ul'"
      end

      define_method '[' do |*args|
        parse '['
      end

      define_method ']' do |*args|
        parse ']'
      end

    #
    # tmac.sdisp
    #

      def DS(*args) # DS - display.  If .DS C, center; L, left-adjust; I, indent.
      end

      def D(*args)
      end

      def CD(*args)
      end

      def ID(*args)
      end

      def LD(*args)
      end

      def XD(*args)
      end

      def BD(*args) # block display: save everything, then center it.
      end

      def DE(*args) # DE - display end
      end

      def DF(*args) # finish a block display to be recentered.
      end

    #
    # tmac.srefs
    #

      define_method '[]' do |*args|
      end

      define_method '][' do |*args|
      end

      define_method '[5' do |*args| # tm style
      end

      define_method '[0' do |*args| # other
      end

      define_method '[1' do |*args| # journal article
      end

      define_method '[2' do |*args| # book
      end

      define_method '[4' do |*args| # report
      end

      define_method '[3' do |*args| # article in book
      end

      define_method ']<' do |*args|
      end

      define_method '[<' do |*args|
      end

      define_method '[>' do |*args|
      end

      define_method ']>' do |*args|
      end

      define_method ']-' do |*args|
      end

      define_method '[-' do |*args|
      end

      define_method ']]' do |*args|
      end

    #
    # tmac.scover
    #

      def OK(*args)
      end

      def CS(*args)
      end

      def CG(*args)
      end

      def CB(*args)
      end

      def CZ(*args)
      end

      def S1(*args)
      end


    #
    # tmac.skeep
    #

      def KS(*args)
      end

      def KQ(*args)
      end

      def KF(*args)
      end

      def FQ(*args)
      end

      def KP(*args)
      end

      def KE(*args)
      end

      def RQ(*args)
      end

    end
  end
end
