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
    incr = case s.slice!(0)
           when '+' then :incr
           when '-' then :decr
           end if s.match?(/^[-+]/)
    s.slice!(0) if s.start_with?('(')
    s = __unesc_star(__unesc_n(s))
    # I think we can get away with relying on the @register default value
    # but let's keep the diagnostic for now.
    #warn "unselected number register #{s.inspect} from set #{@register.keys.inspect} - using 0" unless @register.has_key?(s)
    warn "unselected number register #{s.inspect} - using 0" unless @register.key?(s)
    @register[s].send(incr).tap { warn "auto incrementing register #{s.inspect}" } if incr
    @register[s].to_s
  end
end
