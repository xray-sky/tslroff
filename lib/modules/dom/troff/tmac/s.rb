# tmac.s
#
#   usrdoc (mit afs), others
#   these are not all the same. surprise! check how they differ maybe.
#   this one from 4.3_VAX_MIT
#
# TODO
#   ...everything!
#

module Troff

  define_method 'RT' do |*args| # reset everything to normal state
  end

  define_method 'IZ' do |*args| # initialization
  end

  define_method 'TM' do |*args|
  end

  define_method 'IM' do |*args| # internal memorandum
  end

  define_method 'MF' do |*args| # memorandum for file.
  end

  define_method 'MR' do |*args| # memo for record
  end

  define_method 'EG' do |*args|
  end

  define_method 'LT' do |*args|
  end

  define_method 'OK' do |*args|
  end

  define_method 'RP' do |*args|
  end

  define_method 'TR' do |*args|  # Comp. Sci. Tech Rept series.
  end

  define_method 'TL' do |*args| # title and initialization
  end

  define_method 'TX' do |*args|
  end

  define_method 'AU' do |*args| # author(s)
  end

  define_method 'AX' do |*args|
  end

  define_method 'AI' do |*args| # authors institution
  end

  define_method 'AB' do |*args| # begin an abstract
  end

  define_method 'AE' do |*args| # end of an abstract
  end

  define_method 'SY' do |*args| # cover sheet of released paper
  end

  define_method 'S2' do |*args| # first text page, released paper format
  end

  define_method 'S0' do |*args| # mike lesk conserve paper style
  end

  define_method 'S3' do |*args| # CSTR style
  end

  define_method 'SG' do |*args| # signature
  end

  define_method 'TS' do |*args| # Tables.  TS - table start, TE - table end
  end

  define_method 'TQ' do |*args|
  end

  define_method 'TH' do |*args|
  end

  define_method 'TE' do |*args|
  end

  define_method 'EQ' do |*args|  #equation, breakout and display
  end

  define_method 'EN' do |*args|  # end of a displayed equation
  end

  define_method 'PS' do |*args|	# start picture (bwk)
  end

  define_method 'PE' do |*args|	# end of picture
  end

  define_method 'ME' do |*args|
  end

  define_method 'EM' do |*args| # end up macro - process left over keep-release
  end

  define_method 'NP' do |*args| # new page
  end

  define_method 'XK' do |*args|
  end

  define_method 'KD' do |*args|
  end

  define_method 'PT' do |*args|
  end

  define_method 'FO' do |*args| # footer of page
  end

  define_method '2C' do |*args| # begin double column
  end

  define_method 'MC' do |*args| # multiple columns- arg is line length
  end

  define_method 'RC' do |*args|
  end

  define_method 'C1' do |*args|
  end

  define_method 'C2' do |*args|
  end

  define_method '1C' do |*args| # return to single column format
  end

  define_method 'MH' do |*args|
  end

  define_method 'PY' do |*args|
  end

  define_method 'BT' do |*args|
  end

  define_method 'PP' do |*args| # paragraph
  end

  define_method 'SH' do |*args| # (unnumbered) section heading
  end

  define_method 'NH' do |*args| # numbered heading
  end

  define_method 'BG' do |*args| # begin, execute at first PP
  end

  define_method 'TL' do |*args|
  end

  define_method 'AU' do |*args|
  end

  define_method 'AI' do |*args|
  end

  define_method 'RA' do |*args| #redefine abstract macros
  end

  define_method 'AB' do |*args|
  end

  define_method 'AE' do |*args|
  end

  define_method 'IP' do |*args| # indented paragraph
  end

  define_method 'LP' do |*args| # left aligned (block) paragraph
  end

  define_method 'QP' do |*args|
  end

  define_method 'IE' do |*args| # synonym for .LP
  end

  define_method 'XP' do |*args|
  end

  define_method 'RS' do |*args| # prepare for double indenting
  end

  define_method 'RE' do |*args| # retreat to the left
  end

  define_method 'TC' do |*args|
  end

  define_method 'TD' do |*args|
  end

  define_method 'CM' do |*args| # cut mark
  end

  define_method 'B' do |*args| # bold font
  end

  define_method 'BI' do |*args|	# bold italic -- only on 202
  end

  define_method 'R' do |*args| # Roman font
  end

  define_method 'I' do |*args| # italic font
  end

  define_method 'TA' do |*args| # tabs set in ens or chars
    req_ta(args.join('n ') + 'n')
  end

  define_method 'SM' do |*args| # make smaller size
#.if \\n(.$>0 \&\\$3\s-2\\$1\s0\\$2
#.if \\n(.$=0 .ps -2
  end

  define_method 'LG' do |*args| # make larger size
    req_ps '+2'
  end

  define_method 'NL' do |*args| # return to normal size
    req_ps '\\n(PS'
  end

  define_method 'DA' do |*args| # force date; ND - no date or new date.
#.if \\n(.$ .ds DY \\$1 \\$2 \\$3 \\$4
#.ds CF \\*(DY
  end

  define_method 'ND' do |*args|
#.ME
#.rm ME
#.ds DY \\$1 \\$2 \\$3 \\$4
#.rm CF
  end

  define_method 'FN' do |*args| # footnote end
    send 'FS'
  end

  define_method 'FJ' do |*args|
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

  define_method 'FK' do |*args|
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

  define_method 'FS' do |*args| # First page footer
#.ev1
#.br
#.ll \\n(FLu
#.da FG
  end

  define_method 'FE' do |*args|
#.br
#.di
#.nr FP \\n(dn
#.if \\n(1T=0 .nr KG 1 \"not in abstract repeat next page.
#.if "\\n(.z"OD" .nr KG 0 \" if in OK, don't repeat.
#.ev
  end

  define_method 'FA' do |*args|
#.if t \l'1i'
#.br
  end

  define_method 'FV' do |*args|
#.FS
#.nf
#.ls 1
#.FY
#.ls
#.fi
#.FE
  end

  define_method 'FX' do |*args|
#.if \\n(XX>0 .di FY
#.if \\n(XX>0 .ns
  end

  define_method 'XF' do |*args|
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

  define_method 'FL' do |*args|
#.ev1
#.nr FL \\$1n
#.ll \\$1
#.ev
  end

  define_method 'HO' do |*args|
    parse 'Bell Laboratories'
    parse 'Holmdel, New Jersey 07733'
  end

  define_method 'WH' do |*args|
    parse 'Bell Laboratories'
    parse 'Whippany, New Jersey 07981'
  end

  define_method 'IH' do |*args|
    parse 'Bell Laboratories'
    parse 'Naperville, Illinois 60540'
  end

  define_method 'UL' do |*args| # underline argument, don't italicize
#.if t \\$1\l'|0\(ul'\\$2
  end

  define_method 'UX' do |*args|
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

  define_method 'US' do |*args|
    parse 'the'
    send 'UX'
    parse 'operating system'
  end

  define_method 'QS' do |*args|
    req_br
    send 'LP'
    req_in '+\\n(QIu'
  end

  define_method 'QE' do |*args|
    req_br
    req_in '-\\n(QIu'
    send 'LP'
  end

  define_method 'B1' do |*args| # begin boxed stuff
#.br
#.di BB
#.nr BC 0
#.if "\\$1"C" .nr BC 1
#.nr BE 1
  end

  define_method 'B2' do |*args| # end boxed stuff
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

  define_method 'AT' do |*args|
    req_nf
    req_sp
    parse 'Attached:'
  end

  define_method 'CT' do |*args|
    req_nf
    req_sp
    parse args.any? ? "Copy to #{args[0]}:" : 'Copy to:'
  end

  define_method 'BX' do |*args|
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

  define_method 'DS' do |*args| # DS - display.  If .DS C, center; L, left-adjust; I, indent.
  end

  define_method 'D' do |*args|
  end

  define_method 'CD' do |*args|
  end

  define_method 'ID' do |*args|
  end

  define_method 'LD' do |*args|
  end

  define_method 'XD' do |*args|
  end

  define_method 'BD' do |*args| # block display: save everything, then center it.
  end

  define_method 'DE' do |*args| # DE - display end
  end

  define_method 'DF' do |*args| # finish a block display to be recentered.
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

  define_method 'OK' do |*args|
  end

  define_method 'CS' do |*args|
  end

  define_method 'CG' do |*args|
  end

  define_method 'CB' do |*args|
  end

  define_method 'CZ' do |*args|
  end

  define_method 'S1' do |*args|
  end


#
# tmac.skeep
#

  define_method 'KS' do |*args|
  end

  define_method 'KQ' do |*args|
  end

  define_method 'KF' do |*args|
  end

  define_method 'FQ' do |*args|
  end

  define_method 'KP' do |*args|
  end

  define_method 'KE' do |*args|
  end

  define_method 'RQ' do |*args|
  end


end
