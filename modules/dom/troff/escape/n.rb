# n.rb
# -------------
#   troff
# -------------
#
#   number registers
#
# TODO: lots (autoincrement, roman numerals, etc.)
#

module Troff
  def esc_n(s)
    if s.match(/^n(\(..|.)/) && @state[:register][Regexp.last_match(1)]
      s.sub(/#{Regexp.quote(Regexp.last_match(0))}/,
            @state[:register][Regexp.last_match(1)])
    else
      warn "unselected number register #{s[0..1]} from #{s[2..-1]}"
      s[2..-1]
    end
  end
end
