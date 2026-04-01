# frozen_string_literal: true
#
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

class Troff

  # return one or more input characters.
  # \P counts as one character, as does \*(xx.
  # TODO cope with problems like \f\*(xx where xx is not a defined string (or is defined empty)
  #      without throwing an exception. REVIEW what troff does with this
  #      see:
  #        hpux 10.20 remove_object(1m) \*C problem
  #        du 4.0f dthelpprint(1) [496,501] - \n\n problems

  def get_char(s, offset: 0, count: 1)
    s[offset..get_char_end_pos(s, offset: offset, count: count)]
  end

  def get_char_end_pos(s, offset: 0, count: 1)
    return offset + count unless escapes?
    sptr = offset
    slen = s.length
    loop do
      break if count < 1 or sptr == slen
      if s[sptr] == @escape_character and sptr < slen - 1 # line could end with escape char
        sptr = get_escape_end_pos(s, offset: sptr)
      end
      sptr += 1
      count -= 1
    end
    sptr - 1
  end

  # return one input escape sequence.
  # may be \P, \fP, \*n, \*(nn, \h'|\n(xx+\w'this sucks..'u+3m', etc.

  def get_escape(s, offset: 0)
    s[offset..get_escape_end_pos(s, offset: offset)]
  end

  def get_escape_end_pos(s, offset: 0)
    return offset unless escapes?
    case s[offset + 1]
    when '"'                 then return s.length - 1 # comment
    when 'z'                 then get_printing_char_end_pos(s, offset: offset + 2)
    when '('                 then get_char_end_pos(s, offset: offset + 2, count: 2)
    when 'n'                 then get_reg_str_end_pos(s, offset: offset + 2)
    when 'f', 'g', 'k', '*'  then get_def_str_end_pos(s, offset: offset + 2)
    when 's'                 then get_size_str_end_pos(s, offset: offset + 2)
    when 'b', 'h', 'l', 'o',
         'v', 'w', 'x', 'D',
         'H', 'L', 'S'       then get_quot_str_end_pos(s, offset: offset + 2)
    else offset + 1          # any other escaped character
    end
  end

  # return one definition
  # either a single character, or a two-character definition preceeded by (
  # as accepted by \f, \g, \k, \*, \(, etc.

  def get_def_str(s, offset: 0)
    s[offset..get_def_str_end_pos(s, offset: offset)]
  end

  def get_def_str_end_pos(s, offset: 0)
    s[offset] == '(' ? get_char_end_pos(s, offset: offset + 1, count: 2) : get_char_end_pos(s, offset: offset)
  end

  # return one register
  # either a single character, or a two-character definition preceeded by (
  # may have a + or - in front of the register name

  def get_reg_str(s, offset: 0)
    s[offset..get_reg_str_end_pos(s, offset: offset)]
  end

  def get_reg_str_end_pos(s, offset: 0)
    get_def_str_end_pos(s, offset: (s[offset] == '+' or s[offset] == '-') ? offset + 1 : offset)
  end

  # return one size
  # optional ±, and some number of digits.
  # as accepted by \s
  #
  # REVIEWED - sizes only valid up to 39. \s40 is parsed as \s4 and 0 is copied.
  #            \s0 returns to previous size. \s03 is parsed as \s0 and 3 is copied.
  #            \s+10 is parsed as \s+1 and 0 is copied

  def get_size_str(s, offset: 0)
    s[offset..get_size_str_end_pos(s, offset: offset)]
  end

  def get_size_str_end_pos(s, offset: 0)
    return offset if s[offset].start_with?('0', '4', '5', '6', '7', '8', '9') or !s[offset + 1].match?(/\d/)
    offset + 1
  end

  # get a quoted string
  # second instance of first character terminates
  # as accepted by \h, \w, etc.
  #
  # relies on get_char fetching escapes as single characters
  # to avoid getting tripped up by escaped quotes, or embedded
  # escapes also using the same quote character.

  def get_quot_str(s, offset: 0)
    s[offset..get_quot_str_end_pos(s, offset: offset)]
  end

  def get_quot_str_end_pos(s, offset: 0)
    endchar = get_char(s, offset: offset)
    sptr = offset + endchar.length
    begin
      nextchar = get_char(s, offset: sptr)
      if !nextchar or nextchar == '' # we ran out of characters, probably due to a defect in the source (e.g. ex(1) [GL2-W2.3])
        warn "get_quot_str : ran out of characters in #{s[offset..-1].inspect} looking for matching quote #{endchar.inspect}"
        return sptr
      end
      sptr += nextchar.length
    end until nextchar == endchar
    sptr - 1
  end

  # get one printing character
  # used for \z to collect font changes, vertical shifts, whatever,
  # plus the one printing character that will be output as non-spacing

  def get_printing_char(s, offset: 0)
    s[offset..get_printing_char_end_pos(s, offset: offset)]
  end

  def get_printing_char_end_pos(s, offset: 0)
    sptr = offset
    loop do
      c = get_char(s, offset: sptr)
      sptr += c.length
      break unless c.start_with?(@escape_character) and %w[d f k r s u v x].include?(c[1])
    end
    sptr
  end

  # get one expression
  # used for \l to read a width, .if, etc.

  def get_expression(s)
    strpos = 0
    strlen = s.length
    n = get_num_expr(s[strpos..-1])
    return n if n.empty?
    strpos += n.length

    until strpos == strlen do
      op = get_oper_expr(s[strpos..-1])
      break unless op
      strpos += op.length # might be zero if we're forcing into a (

      e = get_num_expr(s[strpos..-1])
      break unless e
      strpos += e.length
    end
    s[0, strpos]
  end

  # signed magnitude number or parenthesized numeric expression
  def get_num_expr(s)
    n = s.scan(%r(^[-+]*(?:\d*\.?\d+|(?=\()))).first
    return String.new unless n
    strpos = n.length
    strlen = s.length
    return s[0, strpos] if strpos == strlen
    if s[strpos] == '('
      e = get_expression(s[(strpos + 1)..-1])
      return s[0, strpos] unless e
      backpos = strpos + e.length + 1
      strpos = backpos + 1 if s[backpos] == ')'
    end
    strpos += 1 if strpos < strlen and get_unit_expr(s[strpos]) # optional unit
    s[0, strpos]
  end

  def get_oper_expr(s)
    s.scan(%r(^[-+/*%<>=^:])).first
  end

  def get_unit_expr(s)
    s.scan(%r(^[cimnPpuv])).first
  end

end
