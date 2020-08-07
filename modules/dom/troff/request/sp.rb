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
# TODO: negative motion, traps, no-space mode, unit scaling, etc.
# REVIEW: because of constructs like
#            whatever. For example:
#            .sp
#            .in +8
#            .nf
#            star::
#            bigcpu::
#            .fi
#            .in -8
#            .PP
#          this might have to be made to work with <p> -- Xserver(1) [AOS/4.3]
#

module Troff
  def req_sp(n = '1')  # TODO: everything is wrong?
    return if @state[:nospace]
    req_br unless broke?
    v = to_em(to_u(n, default_unit: 'v')) # TODO: hardcoding 1.2 em line height is bogus
    #@current_block << "&roffctl_sp:#{v}em;"
    apply { @current_block.style.css[:margin_top] = "#{v}em" } unless @register[')P'].value == @state[:default_pd]
  end
end
