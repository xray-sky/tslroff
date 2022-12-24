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
# .rs      space    -         D       Restore spacing. The no-space mode is turned off.
#

module Troff
  def req_ns(_argstr = '', breaking: nil)
    @state[:nospace] = true
  end

  def req_rs(_argstr = '', breaking: nil)
    @state.delete(:nospace)
  end
end
