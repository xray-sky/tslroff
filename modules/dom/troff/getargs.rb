# getargs.rb
# ---------------
#    Troff.getargs source
# ---------------
#
# there's a lot going on here.
#
# to be quoted, the arg must begin with a double quote				.ds L" ""
#																	.ds lq \&"
# REVIEW: or does it? -- pc(1) [RISC/ix 1.2]						.BI \-r \*$"[options]"
#         and what the hell is this? perldata(1) [Rhapsody DR2]		.ds T" """""
#         TODO: "pairs of double quotes may be embedded in
#               double-quoted arguments to represent a single double-quote"
#
# anything enclosed in double quotes goes							.TP "\w'\f3~...~\f1\ 0\^\ \ 'u"
# including nothing													.IP "" 5
# an open quote may also be closed by end-of-line					.ds 11 "y\(fm\(fm
#
# .if has a peculiar form for testing string equality				.ie "\\*(.T"480" .ft L
#	and the quotes around a quoted option don't copy				.TH man 1 "September 19, 2005"
#
#	...as evidenced by this two-line contrivance					.tr '"
#																	.BR '...' " 0"
#
# single quotes have no special significance						.ds ' \h'-\w'\(fm\(fm'u'
# unless they do, like for this \w									.TP \w'-N namelist\ \ \ 'u
# an arg may have multiple single-quoted sections					.ds IM \v'.1m'=\v'-.1m'\s-2\h'-.1m'>\h'.1m'\s+2
# or even nested single-quoted sections								.en 0 \h'\w'EIO'u' "Error 0
# but, as mathematical expressions may not contain spaces it probably isn't significant
#
# after all that, one or more unquoted bare spaces (not tabs) terminates an option
# ...as long as there's no escape character in front of it			.I default\ radix
#
# got it?
#
# good.
#
# TODO: details in §7.3
#

module Troff

  def getargs(str)
    esc  = Regexp.quote(@state[:escape_char])
    args = Array.new
    argstr = __unesc_w(str)
    until argstr.empty?
      argstr.sub!(/^(?:"(.*?)(?:(?<!#{esc})"(?: +|$)|$)|(.+?)(?:(?<!#{esc}) +|$))/, '')
      args << Regexp.last_match[1..2].compact.first
    end
    args
  end

end
