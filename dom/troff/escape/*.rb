# (.rb
# -------------
#   troff
# -------------
#
#   basic definitions of the \( (special character) escape
#	most of these are groff-only (man groff_chars) -- TODO: should they be separated?
#

module Troff

  def esc_star(s)
    if s.match(/^\*(\(..|.)/)
      (esc_seq, schar) = Regexp.last_match.to_a 
      s.sub(/#{Regexp.quote(esc_seq)}/, (@state[:named_strings][schar] or "X#{schar}X"))
    else
      "<span style=\"color:green;\">named string #{s[0..1]}</span>#{s[2..-1]}"
    end
  end

end