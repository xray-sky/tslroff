# dt.rb
# -------------
#   troff
# -------------
#
#   §7.5
#
# Request       Initial   If no     Notes   Explanation
#  form          value    argument
#
# .dt N xx      -         off       D,v     Install a diversion trap at position N in
#                                           the current diversion to invoke macro xx.
#                                           Another .dt will redefine the diversion trap.
#                                           If no arguments are given, the diversion trap
#                                           is removed.
#
#  no idea how this is supposed to work, or how it can be made to work in HTML context
#  so far the only use is cmp(1) [GL2-W2.5] and there are no args, so it's a no-op

module Troff

  def req_dt(pos = nil, macro = nil, *args)
    if pos and macro
      warn "!! setting diversion trap #{pos.inspect} #{macro.inspect}"
      pos = pos.to_i
      @state[:diversion_trap][pos] ||= []
      @state[:diversion_trap][pos] << [ macro, args ]
    else
      warn "clearing all diversion traps due to .dt #{pos.inspect} #{macro.inspect}"
      init_dt
    end
  end

  def init_dt
    @state[:diversion_trap] = Hash.new
  end

end
