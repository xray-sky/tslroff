# registers.rb
# -------------
#   troff
# -------------
#
#   \g - format of number registers
#   \n - number registers
#

class Troff

  #   \g - format of number registers
  #
  # TODO: \g will only return a value if the stated register has been set or used;
  #       otherwise, it returns 0.
  #

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

  #   \n - number registers
  #
  #   appears as though an otherwise uninitialized register has a value of 0
  #

  def esc_n(s)
    incr = case s.slice!(0)
           when '+' then :incr
           when '-' then :decr
           end if s.start_with?('-', '+')
    s.slice!(0) if s.start_with?('(')
    s = __unesc_star(__unesc_n(s))

    # I think we can get away with relying on the @register default value
    # but let's keep the diagnostic for now.
    #warn "unselected number register #{s.inspect} - using 0" unless @register.key?(s)

    @register[s].send(incr).tap { warn "auto incrementing register #{s.inspect}" } if incr
    @register[s].to_s
  end

end
