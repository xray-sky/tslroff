# lg.rb
# -------------
#   troff
# -------------
#
#   §10.2
#
# Request      Initial   If no     Notes   Explanation
#  form         value    argument
#
# .lg N        off; on   on          -     Ligature mode is turned on if N is absent
#                                          or non-zero, and turned off if N=0. If N=2,
#                                          only the two-character ligatures are
#                                          automatically invoked. Ligature mode is
#                                          inhibited for request, macro, string, or file
#                                          names, and in copy mode. No effect in nroff.
#
#  REVIEW what happens when given not-an-N as first arg (invalid expression)
#         ignored, I think, which means bad interaction from to_u returning '0' in that case
#
#  TODO implement something (...?)
#

module Troff
  def req_lg(_argstr = '', breaking: nil)
    # TODO: whoops
    warn "unimplemented ligature mode #{_argstr.inspect}"
  end
end
