# if.rb
# -------------
#   troff
# -------------
#
#   conditional acceptance of input
#
#   §16
#
# In the following, c is a one-character, built-in condition name, ! signifies not,
# N is a numerical expression, string1 and string2 are strings delimited by any non-blank,
# non-numeric character not in the strings, and anything represents what is conditionally
# accepted.
#
# Request       Initial   If no     Notes   Explanation
#  form          value    argument
#
# .if c anything   -       -         -      If condition c true, accept anything as input;
#                                           in multi-line case use \{anything\}.
#
# .if !c anything  -       -         -      If condition c false, accept anything.
#
# .if N anything   -       -         -      If expression N > 0, accept anything.
#
# .if !N anything  -       -         -      If expression N ≤ 0, accept anything.
#
# .if 'string1'string2' anything     -      If string1 identical to string2, accept anything.
#
# .if !'string1'string2' anything    -      If string1 not identical to string2, accept anything.
#
# .ie c anything  -        -         u      If portion of if-else; all above forms (like .if).
#
# .el anything    -        -         -      Else portion of if-else.
#
#   The built-in condition names are
#      o      True if current page number is odd
#      e      True if current page number is even
#      t      True if formatter is troff
#      n      True if formatter is nroff
#
#   Any spaces between the condition and the beginning of anything are skipped over.
#   The anything can be either a single input line (text, macro, or whatever) or a number
#   of input lines. In the multi-line case, the first line must begin with a left delimiter
#   \{ and the last line must end with a right delimiter \}. The left delimiter must be
#   followed by either a command or text. Following the left delimiter with a backslash
#   (\{\), escaping the newline, yields an equivalent arrangement.
#
#
# I guess the string comparison delimiters are less restrictive than I expected.
# tmac.an gives examples of both ^G (BEL) and " as delimiters (GL2-W2.5, SunOS 5.5)
# and \(ts is used in mwm(1) [AOS 4.3], so "any" really does mean _any_.
#
#
# remember we came here without our args parsed (split)
# "the last line must end with a right delimiter" apparently doesn't exclude whitespace/comments.
#

module Troff
  def req_ie(argstr = '', breaking: nil, quiet: false)
    @state[:else] = !req_if(argstr, breaking: breaking, quiet: quiet)
  end

  def req_el(argstr = '', breaking: nil)
    resc = Regexp.quote(@state[:escape_char])
    # we probably have a straight else block, .el \{ foo
    # but there is a crazy interaction if there is a block .if we are not going to execute
    if argstr.sub!(/^#{resc}{/, '') or (argstr.match?(/#{resc}{/) and !@state[:else])
      loop do
        parse(argstr) if @state[:else]
        argstr = next_line
        break if argstr.sub!(/#{resc}}\s*(?:\\".*)?$/, '')
      end
    end
    parse(argstr) if @state[:else]
  end

  def req_if(argstr = '', breaking: nil, quiet: false)
    resc = Regexp.quote(@state[:escape_char])
    test = argstr.slice!(0, get_char(argstr).length)
    predicate = if test == '!'
                  test = argstr.slice!(0, get_char(argstr).length)
                  false
                else
                  true
                end

    # get the full escape, if that's what we're on the road to
    # REVIEW I think this is irrelevant now that get_char returns the full escape?
    #test << argstr.slice!(0, get_escape(argstr).length) if test == @state[:escape_char]
    condition = case test
                when 'e', 'E' then quiet or warn 'can\'t test for even page number'
                when 'o', 'O' then quiet or warn 'can\'t test for odd page number'
                when 'n', 't', 'N', 'T'
                  test.downcase == 't'
                when /^[-(0-9]/, /^#{resc}[wn]/  # this is going to be a numeric expression REVIEW is this condition complete?
                  expr = test
                  until argstr.start_with?(' ') or argstr.empty? # sccsfile(4) [HPUX 6.20] has .if !\ns and that's it. causes infinite loop here without .empty?
                    expr << argstr.slice!(0, get_char(argstr).length)
                  end
                  #to_u(__unesc_w(unescape(expr, copymode: true))).to_f.tap { |n| warn ".if evaluating numeric expression #{expr.inspect}" } > 0
                  to_u(expr).to_f.tap { |n| quiet or warn ".if evaluating numeric expression #{expr.inspect}" } > 0
                else
                  # TODO this is getting parsed oddly. maybe the results are ok, but we should figure out the correct deal
                  #      see pvs(1) [SunOS 5.5.1] lines 112, 113
                  quote_char = Regexp.escape test
                  # TODO probably better to re-do this without regexp, using get_char
                  argstr.sub!(%r{(?<lhs>.*?)(?<!(?<!#{resc})#{resc})#{quote_char}(?<rhs>.*?)(?<!(?<!#{resc})#{resc})#{quote_char}}, '')
                  (lhs, rhs) = [Regexp.last_match(:lhs), Regexp.last_match(:rhs)]
                  if lhs.nil? and rhs.nil?
                    # we probably got an invalid condition, which is ignored
                    quiet or warn "invalid condition to .if? #{(test+argstr).inspect} - evaluating as false"
                    false
                  else
                    # warn is too chatty with .}S conditionals coming through here
                    quiet or warn ".if comparing strings #{lhs.inspect} == #{rhs.inspect} is: #{predicate.inspect}?"
                    # this fails; '\f2' == '' -- restore(1m) [ HP-UX 10.20 ]
                    #lhs == rhs
                    lp = Block::Bare.new
                    unescape(lhs, output: lp)
                    rp = Block::Bare.new
                    unescape(rhs, output: rp)
                    lp.to_s == rp.to_s
                  end
                end

    # warn is too chatty with .}S conditionals coming through here
    quiet or warn "rejecting condition#{predicate ? ' ' : ' !'}#{condition.inspect}" unless condition == predicate or test == 'n'

    # TODO if we .TS inside .if \{ \} ,the .TE\} won't happen in the right order (.TS tries to parse .TE with arg \})
    #      we get an exception and things don't reset until after the next .if -- although the output looks ok.
    #      making .TE tolerate receiving args (which it should probably do anyway) suppressed the exception,
    #      but we still parse the .if badly. if the condition is false then we won't have this problem because
    #      .TS is not entered.
    argstr.strip!
    if argstr.sub!(/^#{resc}{\s*/, '')
      loop do
        warn "parsing tbl in block .if -- check correct block end results" if argstr.match?(/^[.']\s*TS/) and condition == predicate
        parse(argstr) if condition == predicate
        argstr = next_line
        break if argstr.sub!(/#{resc}}\s*(?:\\".*)?$/, '')
      end #until argstr.sub!(/#{resc}}$/, '') somehow this never happens; looks like argstr outside of loop context isn't updating
    end
    parse(argstr) if condition == predicate

    # .if needs to return its evaluated condition, so .ie can work
    condition == predicate
  end
end
