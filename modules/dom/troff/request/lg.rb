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
#   TODO: implement something

module Troff
  def req_lg(_args)
    # TODO: whoops
    warn "unimplemented ligature mode #{args.inspect}"
  end
end