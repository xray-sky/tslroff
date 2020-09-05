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
    nr = case s[1]
         when '(' then s[2..3]
         else          s[1]
         end
    if @register[nr]
      @register[nr].format
    else
      warn "unselected number register #{nr} from #{s.inspect}"
      0
    end.to_s + s[2*(nr.length)..-1]
  end
end
