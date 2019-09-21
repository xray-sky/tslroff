# in.rb
# -------------
#   troff
# -------------
#
#   §6
#
# Request       Initial   If no     Notes   Explanation
#  form          value    argument
#
# .in ±N        N=0       previous  B,E,m   Indent is set to ±N. The indent is prepended
#                                           to each output line.
#
#

module Troff
  def req_in(*indent) ; end
end
