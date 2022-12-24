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
# .sp N    -        N=1V      B,‡,v   Space vertically in either direction. If 'N' is
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
#  REVIEW what happens when given not-an-N as first arg (invalid expression)
#         ignored, I think, which means bad interaction from to_u returning '0' in that case
#
# TODO negative motion, traps, no-space mode, unit scaling, etc.
# TODO for some reason (probably to reserve page space?) a.out(4) [GL2-W2.5] has
#           .sp 1i
#           .sp -1i
#       html is output "correctly" but it's not _useful_ to have a span with
#       negative height. now what? might just have to use the rewrite facility.
#
# breaks. TODO can be suppressed with '
#
# TODO getting extra junk following .sp, messing with the spacing;
#      either "<p> </p>", or "<br /> <br />" - probably from space adjust?
#      e.g. eqn(1) [SunOS 5.5.1]
#

module Troff
  def req_sp(argstr = '', breaking: true)  # TODO everything is wrong?
    return if nospace?
    warn ".sp invoked in spacing mode with nobreak - how to?" unless breaking
    n = argstr.split.first || '1'
    v = to_em(to_u(n, default_unit: 'v')) # TODO hardcoding 1.2 em line height is bogus
    (warn "pathological output of .sp #{v}em" ; return) if v < 0
    (req_br ; return) if v == 0
    @current_block << VerticalSpace.new(height: v, font: @current_block.text.last.font.dup,
                                                  style: @current_block.text.last.style.dup)
    # reset tab output position to 0 - TODO revisit what happens if we get a 'sp (non-breaking)
    # REVIEW .sp in tbl (.TS) context w/rt @current_block, etc.
    #        is it worth special casing to give row (bottom-)padding? I think it might be
    #@current_block.reset_output_indicator
  end
end
