# sp.rb
# -------------
#   troff
# -------------
#
#   §5.3
#
# Request  Initial  If no     Notes   Explanation
#  form     value   argument
#
# .sp N    -        N=1V      B,v     Space vertically in either direction. If 'N' is
#                                     negative, the motion is backward (upward) and is
#                                     limited to the distance to the top of the page.
#                                     Forward (downward) motion is truncated to the
#                                     distance to the nearest trap. If the no-space mode
#                                     is on, no spacing occurs (see '.ns' and '.rs').
#
# TODO: negative motion, traps, no-space mode, unit scaling, etc.
# REVIEW: Looks like .sp is meant to cause a break. But I'm not sure.
# REVIEW: is this better accomplished with baseline-shift??
#

module Troff
  def req_sp(n)
    req_br
    v = n.to_f + 1.2 # TODO: hardcoding 1.2 em line height is bogus
    @current_block << "&roffctl_sp:#{v}em;"
  end
end