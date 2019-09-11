# g.rb
# -------------
#   troff
# -------------
#
#   format of number registers
#
# TODO: \g will only return a value if the stated register has been set or used;
#       otherwise, it returns 0.
#

module Troff
  def esc_g(s)
    if s.match(/^g(\(..|.)/) && @register[Regexp.last_match(1)]
      s.sub(/#{Regexp.quote(Regexp.last_match(0))}/,
            @register[Regexp.last_match(1)].format)
    else
      warn "unselected number register #{s[0..1]} from #{s[2..-1]}"
      s[2..-1]
    end
  end
end
