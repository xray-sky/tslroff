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
# Blank text line   -         B       Causes a break and outputs a blank line exactly
#                                     like .sp 1.
#
# .sp 0 is effectively a .br
#
# TODO: negative motion, traps, no-space mode, unit scaling, etc.
# TODO: for some reason (probably to reserve page height) a.out(4) [GL2-W2.5] has
#           .sp 1i
#           .sp -1i
#       html is output "correctly" but it's not _useful_ to have a span with
#       negative height. now what? might just have to use the rewrite facility.
#

module Troff
  def req_sp(n = '1')  # TODO: everything is wrong?
    return if nospace?
    v = to_em(to_u(n, default_unit: 'v')) # TODO: hardcoding 1.2 em line height is bogus
    (warn "pathological output of .sp #{v}em" ; return) if v < 0
    (req_br ; return) if v == 0
    @current_block << "&roffctl_vs:#{v}em;"
    # reset tab output position to 0 - TODO revisit what happens if we get a 'sp (non-breaking)
    @current_block << Text.new(font: @current_block.text.last.font.dup, style: @current_block.text.last.style.dup)
    @current_block.reset_output_indicator
    @current_tabstop = @current_block.text.last
    @current_tabstop[:tab_stop] = 0
  end
end
