# sc.rb
# -------------
#   troff
# -------------
#
#   basic definitions of the \( (special character) escape
#	most of these are groff-only (man groff_chars) -- TODO: should they be separated?
#

module Troff

  def esc_lParen(s)
    s.sub(/^(..)/, @state[:special_chars][Regexp.last_match[1]])
  end

  def init_sc
    h = {
      'bu'	=> '&bull;',
      'co'	=> '&copy;',
      'rg'	=> '&reg;',
      'tm'	=> '&trade;',
      'OK'	=> '&#10003;',	# check mark
      'bs'	=> '<span id="u">TO DO (BELL LABS LOGO)</font>',	# TODO: bell labs logo, not used in groff (cute.)
      'Do'	=> '\$',
      'ct'	=> '&cent;',
      'eu'	=> '&euro;',
      'Eu'	=> '&euro;',	# 'font specific' variant (?)
      'Ye'	=> '&yen;',
      'Po'	=> '&pound;',
      'Cs'	=> '&curr;',
      'Fn'	=> '&fnof;',
      'dd'	=> '&Dagger;',
      'dg'	=> '&dagger;',
      'ps'	=> '&para;',
      'sc'	=> '&sect;',
      'de'	=> '&deg;',
      '%0'	=> '&permil;',
      'fm'	=> '&prime;',
      'sd'	=> '&Prime;',	# double prime - at least GL2-W2.5 man.5 makes use of \(fm\(fm to achieve this
      'Of'	=> '&ordf;',
      'Om'	=> '&ordm;',
      'sq'	=> '&#9633;',	# square
      'ci'	=> '&#9675;',	# circle
      'lz'	=> '&loz;',
      'ul'	=> '_',
      'at'	=> '\@',
      'sh'	=> '\#',
      'cr'	=> '&crarr;',
      '12'	=> '&frac12;',
      '14'	=> '&frac14;',
      '34'	=> '&frac34;',
      '18'	=> '1&frasl;8',
      '38'	=> '3&frasl;8',
      '58'	=> '5&frasl;8',
      '78'	=> '7&frasl;8',
      'S1'	=> '&sup1;',
      'S2'	=> '&sup2;',
      'S3'	=> '&sup3;',
      'pl'	=> '+',
      'mi'	=> '&minus;',
      'eq'	=> '=',			# 'special font'? U003D
      '=='	=> '&equiv;',	# equivalence, U2261
      '>='	=> '&ge;',
      '<='	=> '&le;',
      '<<'	=> '&#8810;',	# much less than, U226A
      '>>'	=> '&#8811;',	# much greater than, U226B
      '!='	=> '&ne;',
      'ne'	=> '&#0338;&#2261;',	# not equivalence, U2261_0338 (overstruck using 'combining long solidus overlay')
      '+-'	=> '&plusmn;',
      '-+'	=> '&#8723;',	# minus plus, U2213
      '=~'	=> '&cong;',
      '|='	=> '&#8871;',	# asymptotically equal to, U2243
      'ap'	=> '&#8764;',	# similar to, U223C
      '~~'	=> '&asymp;',	# approximately equal to, U2248
      '~='	=> '&asymp;',	# same as above
      'pt'	=> '&#8733;',	# proportional to, U221D
      'es'	=> '&#8709;',	# empty set, U2205
      'mo'	=> '&isin;',
      'nm'	=> '&notin;',
      'sb'	=> '&sub;',
      'nc'	=> '&#0338;&#2283;',	# not superset, U2283_0338 (overstruck using 'combining long solidus overlay')
      'ib'	=> '&sube;',
      'ip'	=> '&supe;',
      'ca'	=> '&cap;',
      'cu'	=> '&cup;',
      '/_'	=> '&ang;',
      'pp'	=> '&perp;',
      'is'	=> '&int;',
      'gr'	=> '&nabla;',
      'sr'	=> '&radic;',
      'pc'	=> '&#183;',	# what's the difference between 'period centered' and 'dot operator'?
      'md'	=> '&sdot;',
      'mu'	=> '&times;',
      '**'	=> '&lowast;',
      'c*'	=> '&otimes;',
      'c+'	=> '&oplus;',
      'di'	=> '&divide;',
      'f/'	=> '&frasl;',	# figure slash
      'mc'	=> '&micro;',
      'if'	=> '&infin;',
      'AN'	=> '&and;',
      'OR'	=> '&or;',
      'no'	=> '&not;',
      'te'	=> '&exist;',
      'fa'	=> '&forall;',
      'st'	=> '&ni;',		# groff_chars says U220B, which matches 'contains as member'
      '3d'	=> '&there4;',
      'tf'	=> '&there4;',
      'or'	=> '|',
      'Ah'	=> '&alefsym;',
      'Im'	=> '&image;',
      'Re'	=> '&real;',
      'wp'	=> '&weierp;',
      'pd'	=> '&part;',
      '-h'	=> '&#8463;',	# planck constant over two pi, U210F
      '->'	=> '&rarr;',
      '<-'	=> '&larr;',
      '<>'	=> '&harr;',
      'da'	=> '&darr;',
      'ua'	=> '&uarr;',
      'va'	=> '&#8597;',	# vertical double headed arrow
      'lA'	=> '&lArr;',
      'lh'	=> '&#9756;',	# hand pointing left
      'rA'	=> '&rArr;',
      'rh'	=> '&#9758;',	# hand pointing right
      'hA'	=> '&hArr;',
      'dA'	=> '&dArr;',
      'uA'	=> '&uArr;',
      'vA'	=> '&#8661;',	# double vertical double headed arrow
      'an'	=> '&ndash;',	# approximate horizontal arrow extension
      '-D'	=> '&ETH;',
      'Sd'	=> '&eth;',
      'TP'	=> '&THORN;',
      'Tp'	=> '&thorn;',
      'ss'	=> '&szlig;',
      'fi'	=> 'fi',		# §10.2
      'ff'	=> 'ff',		# §10.2
      'fl'	=> 'fl',		# §10.2
      'Fi'	=> 'ffi',		# §10.2
      'Fl'	=> 'ffl',		# §10.2
      '/L'	=> '&#321;',	# Lslash (polish)
      '/l'	=> '&#323;',	# lslash (polish)
      '/O'	=> '&Oslash;',
      '/o'	=> '&oslash;',
      'AE'	=> '&AElig;',
      'ae'	=> '&aelig;',
      'OE'	=> '&OElig;',
      'oe'	=> '&oelig;',
      'IJ'	=> 'IJ',		# (dutch)
      'ij'	=> 'ij',		# (dutch)
      '.i'	=> '&#305;',	# dotless i (turkish)
      '.j'	=> '&#567;',	# dotless j
      '\'A'	=> '&Aacute;',
      '\'C'	=> '&#262;',	# C acute
      '\'E'	=> '&Eacute;',
      '\'I'	=> '&Iacute;',
      '\'O'	=> '&Oacute;',
      '\'U'	=> '&Uacute;',
      '\'Y'	=> '&Yacute;',
      '\'a'	=> '&aacute;',
      '\'c'	=> '&#263;',	# C acute
      '\'e'	=> '&eacute;',
      '\'i'	=> '&iacute;',
      '\'o'	=> '&oacute;',
      '\'u'	=> '&uacute;',
      '\'y'	=> '&yacute;',
      ':A'	=> '&Auml;',
      ':E'	=> '&Euml;',
      ':I'	=> '&Iuml;',
      ':O'	=> '&Ouml;',
      ':U'	=> '&Uuml;',
      ':Y'	=> '&#376;',	# Y dieresis
      ':a'	=> '&auml;',
      ':e'	=> '&euml;',
      ':i'	=> '&iuml;',
      ':o'	=> '&ouml;',
      ':u'	=> '&uuml;',
      ':y'	=> '&yuml;',
      '^A'	=> '&Acirc;',
      '^E'	=> '&Ecirc;',
      '^I'	=> '&Icirc;',
      '^O'	=> '&Ocirc;',
      '^U'	=> '&Ucirc;',
      '^a'	=> '&acirc;',
      '^e'	=> '&ecirc;',
      '^i'	=> '&icirc;',
      '^o'	=> '&ocirc;',
      '^u'	=> '&ucirc;',
      '`A'	=> '&Agrave;',
      '`E'	=> '&Egrave;',
      '`I'	=> '&Igrave;',
      '`O'	=> '&Ograve;',
      '`U'	=> '&Ugrave;',
      '`a'	=> '&agrave;',
      '`e'	=> '&egrave;',
      '`i'	=> '&igrave;',
      '`o'	=> '&ograve;',
      '`u'	=> '&ugrave;',
      '~A'	=> '&Atilde;',
      '~N'	=> '&Ntilde;',
      '~O'	=> '&Otilde;',
      '~a'	=> '&atilde;',
      '~n'	=> '&ntilde;',
      '~o'	=> '&otilde;',
      'vS'	=> '&Scaron;',
      'vs'	=> '&scaron;',
      'vZ'	=> '&Zcaron;',
      'vz'	=> '&zcaron;',
      ',C'	=> '&Ccedil;',
      ',c'	=> '&ccdeil;',
      'oA'	=> '&Aring;',
      'oa'	=> '&aring;',
      '*A'	=> '&Alpha;',
      '*B'	=> '&Beta;',
      '*G'	=> '&Gamma;',
      '*D'	=> '&Delta;',
      '*E'	=> '&Epsilon;',
      '*Z'	=> '&Zeta;',
      '*Y'	=> '&Eta;',
      '*H'	=> '&Theta;',
      '*I'	=> '&Iota;',
      '*K'	=> '&Kappa;',
      '*L'	=> '&Lambda;',
      '*M'	=> '&Mu;',
      '*N'	=> '&Nu;',
      '*C'	=> '&Xi;',
      '*O'	=> '&Omicron;',
      '*P'	=> '&Pi;',
      '*R'	=> '&Rho;',
      '*S'	=> '&Sigma;',
      '*T'	=> '&Tau;',
      '*U'	=> '&Upsilon;',
      '*F'	=> '&Phi;',
      '*X'	=> '&Chi;',
      '*Q'	=> '&Psi;',
      '*W'	=> '&Omega;',
      '*a'	=> '&alpha;',
      '*b'	=> '&beta;',
      '*g'	=> '&gamma;',
      '*d'	=> '&delta;',
      '*e'	=> '&epsilon;',
      '*z'	=> '&zeta;',
      '*y'	=> '&eta;',
      '*h'	=> '&theta;',
      '*i'	=> '&iota;',
      '*k'	=> '&kappa;',
      '*l'	=> '&lambda;',
      '*m'	=> '&mu;',
      '*n'	=> '&nu;',
      '*c'	=> '&xi;',
      '*o'	=> '&omicron;',
      '*p'	=> '&pi;',
      '*r'	=> '&rho;',
      '*s'	=> '&sigma;',
      'ts'	=> '&sigmaf;',
      '*t'	=> '&tau;',
      '*u'	=> '&upsilon;',
      '*f'	=> '&#981;', # stroked glyph, U03D5
      '*x'	=> '&chi;',
      '*q'	=> '&psi;',
      '*w'	=> '&omega;',
      '+h'	=> '&thetasym;',
      '+f'	=> '&phi;',
      '+p'	=> '&piv;',
      '+e'	=> '&upsih;',
      # there is a whole class of non-spacing glyphs for accenting characters starting \(a.
      # implement them using the Unicode "combining accent" characters (U0300--) - Safari seems to do the right thing with them.
      'a"'	=> '&#779;',	# hungarian umlaut, U030B (U02DD non combining)
      'a-'	=> '&#772;',	# macron, U0304 (U00AF)
      'a.'	=> '&#775;',	# dot, U0307 (U02D9)
      'a^'	=> '&#770;',	# circumflex, U0302 (U005E)
      'aa'	=> '&acute;',	# acute, U0301 (U00B4)
      'ga'	=> '&#768;',	# grave, U0300 (U0060)
      'ab'	=> '&#774;',	# breve, U0306 (U02D8)
      'ac'	=> '&#807;',	# cedilla, U0327 (U00B8)
      'ad'	=> '&#776;',	# dieresis, U0308 (U00A8)
      'ah'	=> '&#780;',	# caron, U030C (U02C7)
      'ao'	=> '&#778;',	# ring, U0306 (U02DA)
      'a~'	=> '&#771;',	# tilde, U0303 (U007E)
      'ho'	=> '&#809;',	# ogonek, U0328 (U02DB)
      # these are explicitly spacing variants
      'ti'	=> '~',			# TODO: nroff treats ~ as small for diacritic, possibly the 'normal' appearance of ~ should be replaced by &tilde; and leave this def as-is
      'ha'	=> '^',
      # quotes
      'Bq'	=> '&bdquo;',
      'bq'	=> '&sbquo;',
      'lq'	=> '&ldquo;',	# .UC
      'rq'	=> '&rdquo;',	# .UC
      'oq'	=> '&lsquo;',
      'cq'	=> '&rsquo;',
      'aq'	=> '\'',
      'dq'	=> '\'',
      'Fo'	=> '&laquo;',
      'Fc'	=> '&raquo;',
      'fo'	=> '&lsaquo;',
      'fc'	=> '&rsaquo;',
      'r!'	=> '&iexcl;',
      'r?'	=> '&iquest;',
      'em'	=> '&mdash;',
      'en'	=> '&ndash;',
      'hy'	=> '-',
      # TODO: besides these braces and brackets, there is a class of glyphs for building extended brackets, etc.
      'lB'	=> '[',
      'rB'	=> ']',
      'lC'	=> '{',
      'rC'	=> '}',
      'la'	=> '&lang;',
      'ra'	=> '&rang;',
      #		'bv'	=> '&#9134;',	# approximate vertical extension, used in GL2-W2.5 fcntl(5)
      'bv'	=> '|',			# unfortunately this is used extensively in GL2-W2.5 to give a vertical bar, and #9134 doesn't exist in the 'normal' font.
      'lt'	=> '&#9127;',	# brace left top
      'lk'	=> '&#9128;',	# brace left mid
      'lb'	=> '&#9129;',	# brace left bot
      'rt'	=> '&#9131;',	# brace right top
      'rk'	=> '&#9132;',	# brace right mid
      'rb'	=> '&#9133;',	# brace right bot
      'ba'	=> '&#9130;',	# bar
      'br'	=> '&#9168;',	# box rule U23D0
      'rn'	=> '&oline;',	# overline rule (radical symbol, top)
      'ru'	=> '_',			# approximate baseline rule
      'lc'	=> '&lceil;',
      'rc'	=> '&rceil;',
      'lf'	=> '&lfloor;',
      'rf'	=> '&rfloor;',
      'sl'	=> '/',
      'rs'	=> '\\',
      'CL'	=> '&clubs;',
      'SP'	=> '&spades;',
      'HE'	=> '&hearts;',
      'DI'	=> '&diams;'
    }
    h.default_proc = proc do |_hash, key|
      "<span style=\"color:green\">#{key}</span>"
    end
    h
  end

end