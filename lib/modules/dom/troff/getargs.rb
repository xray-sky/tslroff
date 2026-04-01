# frozen_string_literal: true
#
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
# Interactive makes it pretty clear that we process the args in copymode first, _then_ split them up
# and also that double quotes need preserving into .ds
# it APPEARS as though double quotes are only lost passing args to macros??
# - I guess that helps with .if/.ie argparsing but it means I need to take care about macros vs. requests!
#

class Troff

  private

  def getargs(s)
    argc = 0
    args = []

    # we will lose trailing whitespace as a natural consequence of parsing
    sptr = 0
    slen = s.length
    while sptr < slen
      arg = get_char s, offset: sptr
      sptr += arg.length
      case arg
      when ' ' then next # whitespace delimited
      when '"' # quoted arg
        arg = String.new # these double quotes don't copy
        loop do
          break if sptr == slen # may be terminated by end of line
          chr = get_char s, offset: sptr
          if chr == '"'
            (sptr += 1 and break) unless (s[sptr + 1] == '"' and sptr += 1) # pairs of double quotes inside double quoted args
          end
          arg << s[sptr, chr.length]
          sptr += chr.length
        end
      else
        loop do
          break if sptr == slen
          chr = get_char s, offset: sptr
          (sptr += 1 and break) if chr == ' '
          arg << s[sptr, chr.length]
          sptr += chr.length
        end
      end
      argc += 1
      args << arg
    end
    @register['.$'].value = argc
    args
  end

end
