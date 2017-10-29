# (.rb
# -------------
#   troff
# -------------
#
#   basic definitions of the \* (named string) escape
#

module Troff
  def esc_star(s)
    if s.match(/^\*(\(..|.)/) && @state[:named_strings][Regexp.last_match(1)]
      s.sub(/#{Regexp.quote(Regexp.last_match(0))}/,
            @state[:named_strings][Regexp.last_match(1)])
    else
      warn "unselected named string #{s[0..1]} from #{s[2..-1]}"
      s[2..-1]
    end
  end
end