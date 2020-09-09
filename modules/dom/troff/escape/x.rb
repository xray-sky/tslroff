# x.rb
# -------------
#   troff
# -------------
#
#   definition of the \x (extra line space function) escape
#
# negative before, positive after
#
# REVIEW '0' arg - see spline(1g) [GL2-W2.5]
# REVIEW does it actually use delimiters??
#
# TODO what does this actually DO??
#

module Troff
  def esc_x(s)
    esc = Regexp.quote(@state[:escape_char])
    s.match(/(^x([#{@@delim}])(.+?(#{esc}\2)*)\2)/)
    (_, full_esc, quote_char, req_str) = Regexp.last_match.to_a

    warn "don't know how to #{full_esc.inspect}!"

    s.sub(/#{Regexp.quote(full_esc)}/, '')
  end
end
