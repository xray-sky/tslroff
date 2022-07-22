# l.rb
# -------------
#   troff
# -------------
#
#   §12.4
#
#   \l'Nc' draws a string of repeated characters 'c' toward the right for a distance of N
#   if c looks like a continuation of an expression for N, it may be insulated from N with
#   a \&. If c is not specified, the _ (baseline rule) is used. If N is negative, a
#   backward horizontal motion of size N is made before drawing the string. Any space
#   resulting from N/(size of c) having a remainder is put at the beginning (left end) of
#   the string. In the case of characters that are designed to be connected such as
#   baseline-rule, underrule, and root-en, the remainder space is covered by overlapping.
#   If N is less than the width of c, a single c is centered on a distance N. As an example,
#   a macro to underscore a string can be written
#
#     .de us
#     \\$1\ l ' | 0\(ul'
#     ..
#
#    MORE
#
#    TODO
#
#    WTF
#

module Troff
  def esc_l(s)
    quotechar = Regexp.quote(get_char(s))
    req_str = s.sub(/^#{quotechar}(.*)#{quotechar}$/, '\1')
    warn "\\l trying to draw lines from #{req_str.inspect}"
    unescape(req_str)
  end
  def esc_L(s)
    quotechar = Regexp.quote(get_char(s))
    req_str = s.sub(/^#{quotechar}(.*)#{quotechar}$/, '\1')
    warn "\\L trying to draw lines from #{req_str.inspect}"
    unescape(req_str)
  end
  def esc_D(s)
    quotechar = Regexp.quote(get_char(s))
    req_str = s.sub(/^#{quotechar}(.*)#{quotechar}$/, '\1')
    warn "\\D trying to draw lines from #{req_str.inspect}"
    unescape(req_str)
  end
end
