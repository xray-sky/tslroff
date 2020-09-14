# n.rb
# -------------
#   troff
# -------------
#
#   number registers
#
#   appears as though an otherwise uninitialized register has a value of 0
#

module Troff
  def esc_n(s)
    (req, incr, reg) = s.match(/^n([-+])?(?:(\(..|.))/).to_a
    reg.tr!('(', '') if reg and reg.length > 1
    if req and @register[reg]
      @register[reg].send(incr) if incr
      s.sub(/#{Regexp.quote(req)}/, @register[reg].to_s)
    else
      warn "unselected number register #{reg} from #{s} - using 0"
      s.sub(/#{Regexp.quote(req)}/, '0')
    end
  end
end
