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
# TODO: details in §7.3 (including "arguments are copied in copy mode onto a stack")
#

module Troff

  def getargs(str)
    resc  = Regexp.quote(@state[:escape_char].to_s)	# escape mechanism may be disabled
    args = Array.new
    #argstr = str.sub(%r{\s*\\".*$}, '')	# kill any comments => usr/athena/etc/tmac.h [AOS-4.3]
    # Interactive makes it pretty clear that we process the args in copymode first, _then_ split them up
    # and also that double quotes need preserving into .ds
    # it APPEARS as though double quotes are only lost passing args to macros??
    # - I guess that helps with .if/.ie argparsing but it means I need to take care about macros vs. requests!
    argstr = __unesc_w(unescape(str.sub(%r{\s*\\".*$}, ''), copymode: true))
    until argstr.empty?
      #argstr.sub!(/^(?:"(.*?)(?:(?<!#{resc})"(\S*)(?: +|$)|$)|(.+?)(?:(?<!#{resc}) +|$))/, '')
      #args << __unesc_w(unescape(Regexp.last_match[1..3].join, copymode: true))

      # eat leading space
      arg = argstr.slice!(0, get_char(argstr).length)
      case arg
      when ' ' then next
      when '"'
        arg = '' # these double quotes don't copy
        loop do
        #warn "getargs building quoted arg #{arg.inspect}"
          break if argstr.empty?
          chr = get_char(argstr)
          if chr == '"'
            argstr.slice!(0) # eat this double quote
            break if get_char(argstr) != '"' # pairs of double quotes inside double quoted args
          end
          arg << argstr.slice!(0, chr.length)
        end
        #args << __unesc_w(unescape(arg, copymode: true))
      else
        loop do
        #warn "getargs building unquoted arg #{arg.inspect}"
          break if argstr.empty?
          chr = get_char(argstr)
          break if chr == ' '
          arg << argstr.slice!(0, chr.length)
        end
      end
      #args << __unesc_w(unescape(arg, copymode: true))
      args << arg
    end
    args#.tap {|n| warn "giving args #{n.inspect}" }
  end

end
