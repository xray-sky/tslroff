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

  def get_char(s, count:  1)
    chars = s[0]
    while count > 1
      chars << if chars.end_with?(@state[:escape_char])
                 get_escape(s[(chars.length)..-1])#.tap {
               else
                 get_char(s[(chars.length)..-1])#.tap {
               end
      count -= 1
    end
    chars
  end

# return one input escape sequence.
# may be \P, \fP, \*n, \*(nn, \h'|\n(xx+\w'this sucks..'u+3m', etc.

  def get_escape(s)
   esc = get_char(s)
   esc << case esc
          when '"'                     then s[1..-1]
          when 'z'                     then get_char(s[1..-1])
          when '('                     then get_char(s[1..-1], count: 2)#.tap {|n| warn "returned #{n.inspect} for \\( " }
          when 'f', 'g', 'k', 'n', '*' then get_def_str(s[1..-1])#.tap {|n| warn "returned #{n.inspect} from get_def_str" }
          when 's'                     then get_size_str(s[1..-1])#.tap {|n| warn "returned #{n.inspect} from get_size_str" }
          when 'b', 'h', 'l', 'o',
               'v', 'w', 'x', 'L', 'D' then get_quot_str(s[1..-1])#.tap {|n| warn "returned #{n.inspect} from get_quot_str" }
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
    req << get_char(s[n]) and n = 2 if req =~ /[-+]/
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
      n += nextchar.length
      req << nextchar
    end until nextchar == endchar
    req
  end

end
