# ns.rb
# -------------
#   troff
# -------------
#
#   §5.3
#
# Request  Initial  If no     Notes   Explanation
#  form     value   argument
#
# .ns      space    -         D       No-space mode turned on. When on, the no-space
#                                     mode inhibits .sp requests and .bp requests without
#                                     a next page number. The no-space mode is turned off
#                                     when a line of output occurs, or with .rs
#

module Troff
  def req_ns(*_args)
    warn ".ns pointlessly received args #{_args.inspect} - why?" if _args.any?
    @state[:nospace] = true
  end
end
