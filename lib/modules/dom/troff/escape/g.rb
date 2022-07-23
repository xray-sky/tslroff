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
    warn "use of \\g - #{s.inspect} (check)"
    s.slice!(0) if s.start_with?('(')
    if @register[s]
      @register[s].format
    else
      warn "unselected number register #{s} from #{s.inspect}"
      0
    end.to_s
  end
end
