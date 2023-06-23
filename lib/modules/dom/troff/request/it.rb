# it.rb
# -------------
#   troff
# -------------
#
#   §7.5
#
# Request       Initial   If no     Notes   Explanation
#  form          value    argument
#
# .it N xx      -         off       E       Set an input-line-count trap to invoke the
#                                           macro xx after N lines of text input have
#                                           been read (control or request lines don't
#                                           count). The text may be in-line or trap-
#                                           invoked macros representing text. (See the
#                                           discussion of the input-line-count .it
#                                           request in section 7.5, "Traps.")
#
#  REVIEW what happens when given not-an-N as first arg (invalid expression)
#         ignored, I think, which means bad interaction from to_u returning '0' in that case
#
#

module Troff

  def req_it(argstr = '', breaking: nil)
    (count, macro) = argstr.split
    if count and macro
      count = count.to_i
      macro = "req_#{macro}" if Requests.include? macro and respond_to?("req_#{macro}")
      @state[:input_trap][count] ||= []
      @state[:input_trap][count] << [ macro ]
    else
      warn "clearing all input traps due to .it #{count.inspect} #{macro.inspect}"
      init_it
    end
  end

  def init_it
    @state[:input_trap] = Hash.new
  end

end
