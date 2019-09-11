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
#  REVIEW: what is "trap-invoked macros representing text"?
#          -> .de and .ds are considered traps, so .B and other similar macros would be
#             covered here? (answer: yes.)
#
#  TODO (maybe): it's unfortunate that I haven't got a better plan than to explicitly
#        call process_input_traps() from macros which output text and therefore count for input
#
#  REVIEW: is the implication from no arg meaning "off" that there can only be one set at a time?
#          -> .TP makes use of .it, as does .B, which suggests.. 1) no, and 2) it should
#             perhaps work like a stack?
#

module Troff

  def req_it(count = nil, macro = nil, *args)
    if count and macro
      @state[:input_trap][count] ||= []
      @state[:input_trap][count] << [ macro, args ]
    else
      warn "clearing all input traps due to .it #{count.inspect} #{macro.inspect}"
      init_it
    end
  end

  def init_it
    @state[:input_trap] = Hash.new
  end

end
