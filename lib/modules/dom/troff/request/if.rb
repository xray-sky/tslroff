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
# TODO: I guess the string comparison delimiters are less restrictive than I expected.
#       tmac.an gives examples of both ^G (BEL) and " as delimiters (GL2-W2.5, SunOS 5.5)
#       and \(ts is used in mwm(1) [AOS 4.3], so "any" really does mean _any_.
#
# REVIEW: I might get into trouble with getargs() losing outer double-quotes,
#         telling the difference between string comparison and a numeric expression
#

module Troff
  def req_if(*args)
    esc = Regexp.quote(@state[:escape_char])
    test = args.shift
    predicate = (test.sub!(/^!/, '') ? false : true)
    condition = case test[0]
                when 'e', 'E' then warn 'can\'t test for even page number'
                when 'o', 'O' then warn 'can\'t test for odd page number'
                when 't', 'T', 'n', 'N'
                  pred = test[0]
                  args = [test[1..-1]] + args if test[1]
                  test = pred.downcase
                  test == 't'
                when /\d/
                  # try to evaluate it as an expression
                  # REVIEW: are we going to get expressions not starting with digits?
                  # \n and \w should already be processed by the time we get here.
                  expr = to_u(test).to_f
                  expr > 0
                else
                  warn "evaluating condition #{test.inspect} as string comparison"
                  # TODO some joker's used a special character as a delim in mwm(1), saber(1) [AOS 4.3]
                  # .if \(ts\n(.z\(ts\(ts - good grief. sigma?! I guess that is going to take a rewrite rule.
                  #test.sub!("\\(ts", '"') - do this as a reusable method that will interpret the next char as an escape - we need it for all esc processing (e.g. \n(\f1, \f\P)
                  test.match(/^([#{@@delim}])(.*?)\1(.*?)\1$/) or test.match(/^([^@@delim].*?)"(.*?)$/) # TODO: _any_ delimiter
                  (str1, str2) = Regexp.last_match[-2..-1]
                  #warn "don't know how to compare strings #{str1.inspect} and #{str2.inspect}"
                  __unesc_star(str1) == __unesc_star(str2)  # TODO this needs to expand named strings without interfering with output - mhook(1) [AOS 4.3]
                end

    # multi-line input
    input = if args[0].sub!(/^#{esc}{/, '')
      @lines.collect_through do |line|
        @register['.c'].incr # TODO oops, this will go nuts if we have multiple collect_through (e.g., .de inside .if)
        line.sub!(/#{esc}}\s*$/, '')  # comb(1), delta(1) [GL2-W2.5]
      end
    else
      Array.new
    end

    # there's a strange case here if the first line of input is a command, since
    # the args have already been parsed.
    #
    # TODO: actually this is not good, because of things like this -- sh(1) [GL2-W2.5]
    #       .if n if then else elif fi case esac for while until do done { }
    #       .if t if  then  else  elif  f\|i  case  esac  for  while  until  do  done  {  }
    #
    input.unshift(Troff.req?(args[0]) ? "#{args.shift} #{args.map { |arg| %("#{arg}") }.join(' ')}" : args.join(' '))
    if condition == predicate
      input.each { |line| parse(line) }
      true
    else
      warn "rejected condition #{predicate ? '' : '!'}#{test.inspect}" unless test == 'n'
      false
    end
  end
end
