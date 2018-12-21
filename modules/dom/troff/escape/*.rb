# (.rb
# -------------
#   troff
# -------------
#
#   basic definitions of the \* (named string) escape
#

module Troff
  def esc_star(s)
    # REVIEW: shortcut - I think it's okay to delete all ( from the match
    #                    \*( as a single-char is clearly not allowable
    #                    \*((. and \*(.( maybe could, though crazy?
    if s.match(/^\*(?:(\(..|.))/) && @state[:named_string][Regexp.last_match(1).delete('(')]
      warn "named string with ( !! -- #{Regexp.last_match(1).inspect}" if Regexp.last_match[1].count('(') > 1
      s.sub(/#{Regexp.quote(Regexp.last_match(0))}/,
            @state[:named_string][Regexp.last_match(1).delete('(')])
    else
      warn "named string with ( !! -- #{Regexp.last_match(1).inspect}" if Regexp.last_match[1].count('(') > 1
      warn "unselected named string #{s[0..1]} from #{s[2..-1]}"
      s[2..-1]
    end
  end
end