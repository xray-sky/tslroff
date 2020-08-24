# (.rb
# -------------
#   troff
# -------------
#
#   basic definitions of the \* (named string) escape
#
#  the string could contain escapes that need further processing
#          e.g. '.dsS \s\n()S'
#    so we send back the expanded string, so that it might be unescaped
#
#  TODO: align this implementation with \n
#

module Troff
  def esc_star(s)
    # REVIEW: shortcut - I think it's okay to delete all ( from the match
    #                    \*( as a single-char is clearly not allowable
    #                    \*((. and \*(.( maybe could, though crazy?
    if s.match(/\*(?:(\(..|.))/)
      ds = Regexp.last_match(1).start_with?('(') ? Regexp.last_match(1)[1..-1] : Regexp.last_match(1)
      if @state[:named_string][ds]
        s.sub(/#{Regexp.quote(Regexp.last_match(0))}/, @state[:named_string][ds])
      else
        warn "unselected named string #{s[0..1]} from #{s[2..-1]}"
        s[2..-1]
      end
    end
  end
end
