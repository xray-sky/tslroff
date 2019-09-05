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
    (req, reg) = s.match(/^n(?:(\(..|.))/).to_a
    reg.tr!('(', '') if reg and reg.length > 1
    if req and @state[:register][reg]
      s.sub(/#{Regexp.quote(req)}/, @state[:register][reg].value.to_s)
    else
      warn "unselected number register #{s[0..1]} from #{s[2..-1]} (#{Regexp.last_match.inspect})"
      s[2..-1]
    end
  end
end
