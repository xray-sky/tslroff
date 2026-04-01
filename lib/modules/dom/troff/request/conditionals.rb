# frozen_string_literal: true
#
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
# "the last line must end with a right delimiter" apparently doesn't preclude whitespace/comments.
#

class Troff
  def ie(argstr = '', breaking: nil, quiet: true)
    #warn ".ie : sending #{argstr.inspect} to .if"
    @else = !send(:if, argstr, breaking: breaking, quiet: quiet)
  end

  def el(argstr = '', breaking: nil)
    #warn ".ie : processing #{argstr.inspect}"
    resc = Regexp.quote(@escape_character)
    # we probably have a straight else block, .el \{ foo
    # but there is a crazy interaction if there is a block .if we are not going to execute
    if argstr.sub!(/^#{resc}{/, '') or (argstr.match?(/#{resc}{/) and !@else)
      loop do
        #warn ".el : looping on #{argstr.inspect} to #{@else ? "run" : "not run"}"
        parse(argstr) if @else
        argstr = next_line
        break if argstr.sub!(/#{resc}}\s*(?:\\".*)?$/, '')
      end
    end
    #warn ".el : parsing final #{argstr.inspect} to #{@else ? "run" : "not run"}"
    parse(argstr) if @else
  end

  define_method 'if' do |argstr = '', breaking: nil, quiet: true|
    resc = Regexp.quote(@escape_character)

    # block .if? set aside the command or text
    #argstr.sub! %r{\s*(?<!#{resc})#{resc}\{\s*(.*)$}, ''
    #block = Regexp.last_match&.[](1)
    blockpos = argstr.index %r{\s*(?<!#{resc})#{resc}\{\s*(.*)$}

    strpos = 0
    negate = true and strpos += 1 if argstr.start_with? '!'
    test_op = get_char argstr[strpos..-1]

    # get the full escape, if that's what we're on the road to
    condition = case test_op
                when 'e', 'E'
                  strpos += 1
                  warn %(can't test for even page number) unless quiet
                when 'o', 'O'
                  strpos += 1
                  warn %(can't test for odd page number) unless quiet
                when 'n', 't', 'N', 'T'
                  strpos += 1
                  negate ^ (test_op.downcase == 't')
                # numeric expression
                # REVIEW is this condition complete?
                when /^(?:[-.(0-9]|#{resc}[wn])/
                  (predicate, exprlen) = test_numeric(argstr[strpos..-1], quiet: quiet)
                  strpos += exprlen
                  negate ^ predicate.tap do |c|
                    # warn is too chatty with .}S conditionals coming through here
                    warn "    calculated #{"negated " if negate}#{test_op.inspect} predicate: #{c.inspect}" unless quiet
                  end
                # string comparison
                else
                  (predicate, strlen) = test_string(argstr[strpos..-1], quiet: quiet)
                  strpos += strlen
                  negate ^ predicate.tap do |c|
                    # warn is too chatty with .}S conditionals coming through here
                    warn "    calculated #{"negated " if negate}#{test_op.inspect} predicate: #{c.inspect}" unless quiet
                  end
                end


    # TODO if we .TS inside .if \{ \} ,the .TE\} won't happen in the right order (.TS tries to parse .TE with arg \})
    #      we get an exception and things don't reset until after the next .if -- although the output looks ok.
    #      making .TE tolerate receiving args (which it should probably do anyway) suppressed the exception,
    #      but we still parse the .if badly. if the condition is false then we won't have this problem because
    #      .TS is not entered.
    if blockpos
      block = argstr[blockpos..-1]
      rcc = Regexp.quote("#{@cc}#{@c2}")
      loop do
        #warn ".if : looping on #{argstr.inspect} to #{condition ? "run" : "not run"}"
        if condition
          warn "parsing tbl in block .if -- check correct block end results" if block.match?(/^[#{rcc}]\s*TS/)
          parse block
        end
        block = next_line
        break if block.sub!(/#{resc}}\s*(?:\\".*)?$/, '')
      end
      parse block unless block.empty?
    else
      #warn ".if : single line on #{argstr.inspect} to #{condition ? "run" : "not run"}"
      parse(argstr[strpos..-1].lstrip) if condition
    end

    # .if needs to return its evaluated condition, so .ie can work
    condition
  end

  private

  def test_numeric(e, quiet: false)
    expr = get_expression(__unesc_w(e)).tap { |n| warn ".if evaluating numeric expression #{n.inspect}" unless quiet }
    [to_u(expr).to_i > 0, expr.length]
  end

  def test_string(e, quiet: false)
    lhs = get_quot_str(e)[1..-2] # lose the quotes
    rhs = get_quot_str(e, offset: lhs.length + 1)[1..-2] # lose the quotes

    warn ".if comparing strings #{lhs.inspect} == #{rhs.inspect}" unless quiet
    lp = Block::Bare.new
    rp = Block::Bare.new
    unescape lhs, output: lp
    unescape rhs, output: rp
    [lp.to_s == rp.to_s, rhs.length + lhs.length + 3] # three total quote chars - "lhs"rhs"
  end
end
