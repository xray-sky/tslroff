# bp.rb
# -------------
#   troff
# -------------
#
#   §3
#
# Request       Initial   If no     Notes   Explanation
#  form          value    argument
#
# .bp ±N        N=1       -         B,‡,v   Break page. The current page is ejected and
#                                           a new page is begun. If ±N is given, the new
#                                           page number will be ±N. Also see request .ns.
#
# TODO anything?
# REVIEW ar(1) [GL2-W2.5] for use in practice
#

module Troff
  def req_bp(*)
  end
end
