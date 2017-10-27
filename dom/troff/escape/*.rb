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
      str = @state[:named_strings][schar.to_sym] || "||#{schar}||"
      @current_block << str
      s.sub(/#{Regexp.quote(esc_seq)}/, '')
    else
      %(<span style="color:green;">named string #{s[0..1]}</span>#{s[2..-1]})
    end
  end
end