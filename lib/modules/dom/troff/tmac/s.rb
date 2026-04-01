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

  def RT(*args) # reset everything to normal state
    send 'BG' if @register['1T'] <= 0
    req_ce '0'
    req_di if @register['IK'] <= 0 and @register['IF'] <= 0 and @register['IX'] <= 0 and @register['BE'] <= 0
    req_ul '0'
    if @register['QP'] > 0
      #req_ll '+\n(QIu'
      req_in '-\n(QIu'
      req_nr 'QP -1'
    end
    #req_ll '\n(LLu' if @register['NX'] <= 1 and @register['AJ'].zero?
    if @register['IF'].zero?
      req_ps '\n(PS'
      req_vs '\n(VSu' if @register['VS'] >= 41
      req_vs '\n(VSp' if @register['VS'] <= 40
    end
    req_in '\n(I\n(IRu' if @register['IP'] > 0
    if @register['IP'].zero? and @register['IR'].zero?
      req_nr 'I1 \n(PIu'
      %w[I2 I3 I4 I5 J0 J1 J2 J3 J4 J5].each { |r| req_nr "#{r} 0" }
    end
    req_nr 'IP -1' if @register['IP'] > 0
    req_ft 1
    req_bd 1
    req_ta '5n 10n 15n 20n 25n 30n 35n 40n 45n 50n 55n 60n 65n 70n 75n 80n'
    req_fi
  end

  def IZ(*args) # initialization
    req_nr 'TN 0'
    req_em 'EM'
    # REVIEW are HTML entities safe through \* ?? - this might take rewrites (\*'e or \*`e to get é or è)
    #req_ds %(' ) # non-spacing acute accent
    #req_ds %(` ) # non-spacing grave accent
    #req_ds ': ' # non-spacing umlaut
    #req_ds '^ ' # non-spacing circumflex
    #req_ds '~ ' # non-spacing tilde accent
    #req_ds 'C ' # non-spacing hacek (majuscule - case immaterial for html)
    #req_ds 'v ' # non-spacing hacek (minuscule - case immaterial for html)
    #req_ds ', ' # non-spacing cedilla
    # TODO some non-.de stuff from tmac.srefs
    req_ds %([. \\s-2\\v'-.4m'\\f1)
    req_ds %(.] \\v'.4m'\\s+2\\fP)
    req_ds %([o ``)
    req_ds %([c '')
    req_ch 'FO \n(YYu'
    req_nr 'FM 1i' if @register['FM'].zero?
    req_nr 'YY -\n(FMu'
    req_nr 'XX 0 1'
    req_nr 'IP 0'
    req_nr 'PI 5n'
    req_nr 'DV .5v'
    req_nr 'QI 5n'
    req_nr 'I0 \n(PIu'
    req_nr 'PS 10'
    req_nr 'VS 12'
    req_nr 'PD 0.3v' if @register['PD'] <= 0
    req_nr 'ML 3v'
    req_ps '\n(PS'
    req_vs '\n(VSu' if @register['VS'] >= 41
    req_vs '\n(VSp' if @register['VS'] <= 40
    req_nr 'IR 0'
    req_nr 'I0 0'
    req_nr 'I1 \n(PIu'
    req_nr 'TB 0'
    req_nr 'SJ \n(.j'
    req_nr 'LL 6i'
    #req_ll '\n(LLu'
    req_nr 'LT \n(.l'
    req_lt '\n(LTu'
    req_ev '1'
    req_nr 'FL \n(LLu*11u/12u'
    #req_ll '\n(FLu'
    req_ps '8'
    req_vs '10p'
    req_ev
    req_if '\000\*(CH\000\000 .ds CH "\(hy \\n(PN \(hy'
    req_wh '0 NP'
    req_wh '-\n(FMu FO'
    req_ch 'FO 16i'
    req_wh '-\n(FMu FX'
    req_ch 'FO '-\n(FMu'
    req_wh '-\n(FMu/2u BT'
    req_nr 'CW 0-1'
    req_nr 'GW 0-1'
  end

  def TM(*args)
  end

  def IM(*args) # internal memorandum
  end

  def MF(*args) # memorandum for file.
  end

  def MR(*args) # memo for record
  end

  def EG(*args)
  end

  def LT(*args)
  end

  def OK(*args)
  end

  def RP(*args)
  end

  def TR(*args)  # Comp. Sci. Tech Rept series.
  end

  def TL(*args) # title and initialization
  end

  def TX(*args)
  end

  def AU(*args) # author(s)
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

  def 2C(*args) # begin double column
  end

  def MC(*args) # multiple columns- arg is line length
  end

  def RC(*args)
  end

  def C1(*args)
  end

  def C2(*args)
  end

  def 1C(*args) # return to single column format
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
    send 'UX'
    parse 'operating system'
  end

  def QS(*args)
    br
    send 'LP'
    in '+\\n(QIu'
  end

  def QE(*args)
    br
    send 'in', '-\\n(QIu'
    send 'LP'
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
