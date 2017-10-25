# (.rb
# -------------
#   troff
# -------------
#
#   basic definitions of the \* (named string) escape
#

module Troff
  def esc_star(s)
    if s.match(/^\*(\(..|.)/)
      (esc_seq, schar) = Regexp.last_match.to_a 
      s.sub(/#{Regexp.quote(esc_seq)}/, (@state[:named_strings][schar] or "||#{schar}||"))
    else
      %(<span style="color:green;">named string #{s[0..1]}</span>#{s[2..-1]})
    end
  end
end