# methods for tokenizing input lines
#
#  where there are many kinds of edge cases -
#  troff may treat \*(xx as a single character
#  and expressions like \f\P are equivalent to \fP (REVIEW: not according to os x nroff; \f is ignored and \P is copied)
#  and escapes may be escaped
#  and arbitrary sequences may be quoted, with quotes
#    enclosing other arbitrary quoted sequences, sometimes
#    even using the same quote characters.
#
# these methods are _not_ destructive of s
#

module Troff

# return one or more input characters.
# \P counts as one character, as does \*(xx.
# TODO cope with problems like \f\*(xx where xx is not a defined string (or is defined empty)
#      without throwing an exception. REVIEW what troff does with this
#      see:
#        hpux 10.20 remove_object(1m) \*C problem
#        du 4.0f dthelpprint(1) [496,501] - \n\n problems

  def get_char(s, count:  1)
    chars = ''
    loop do
      break if count < 1 or s.empty?
      chars << s[chars.length]
      chars << get_escape(s[(chars.length)..-1]) if chars.end_with?(@state[:escape_char]) and chars.length < s.length # might end with an escape char
      count -= 1
    end
    chars
  end

# return one input escape sequence.
# may be \P, \fP, \*n, \*(nn, \h'|\n(xx+\w'this sucks..'u+3m', etc.

  def get_escape(s)
   esc = s[0]
   esc << case esc
          when '"'                     then s[1..-1]
          when 'z'                     then get_printing_char(s[1..-1])
          when '('                     then get_char(s[1..-1], count: 2)
          when 'f', 'g', 'k', 'n', '*' then get_def_str(s[1..-1])
          when 's'                     then get_size_str(s[1..-1])
          when 'b', 'h', 'l', 'o', 'v', 'w', 'x',
               'D', 'H', 'L', 'S'      then get_quot_str(s[1..-1])
          else ''
          end
    esc
  end

# return one definition
# either a single character, or a two-character definition preceeded by (
# as accepted by \f, \g, \k, \n, \*, \(, etc.
# \n may have a + or - in front of the register name

  def get_def_str(s)
    req = get_char(s)
    n = 1
    req << get_char(s[n]) and n = 2 if %[- +].include? req
    req << get_char(s[n..-1], count: 2) if req.end_with? '('
    req
  end

# return one size
# optional ±, and some number of digits.
# as accepted by \s
#
# REVIEWED - sizes only valid up to 39. \s40 is parsed as \s4 and 0 is copied.
#            \s0 returns to previous size. \s03 is parsed as \s0 and 3 is copied.
#            \s+10 is parsed as \s+1 and 0 is copied

  def get_size_str(s)
    siz = s.slice!(0, get_char(s).length)
    return siz if %w(0 4 5 6 7 8 9).include?(siz)
    max_digits = 1 if siz.match?(/^\d/)
    next_char = get_char(s)
    siz << next_char if next_char.match?(/^\d$/)
  	siz
  end

# get a quoted string
# second instance of first character terminates
# as accepted by \h, \w, etc.
#
# relies on get_char fetching escapes as single characters
# to avoid getting tripped up by escaped quotes, or embedded
# escapes also using the same quote character.

  def get_quot_str(s)
    endchar = get_char(s)
    req = endchar.dup # attend!
    n = req.length
    begin
      nextchar = get_char(s.slice(n..-1)) # REVIEW is .slice redundant
      if nextchar == '' # we ran out of characters, probably due to a defect in the source (e.g. ex(1) [GL2-W2.3])
        warn "get_quot_str ran out of characters in #{s.inspect} looking for matching quote"
        return req
      end
      n += nextchar.length
      req << nextchar
    end until nextchar == endchar
    req
  end

# get one printing character
# used for \z to collect font changes, vertical shifts, whatever,
# plus the one printing character that will be output as non-spacing

  def get_printing_char(s)
    req = ''
    loop do
      c = get_char s
      if c.start_with?(@state[:escape_char]) and %w[d f k r s u v x].include?(c[1])
        req << s.slice!(0, c.length)
      else
        break
      end
    end
    req << s.slice!(0, get_char(s).length)
  end
end

# get one expression
# used for \l to read a width

  def get_expression(s)
    #s.scan(/^[-|]?[\d.]+[cimnPpuv]?/).first
    s.scan(%r(^[-|]?[\d\.cimnPpuv]+|[-+/*%<>=&:]+)).first
  end
