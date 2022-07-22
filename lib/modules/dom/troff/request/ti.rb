# ti.rb
# -------------
#   troff
# -------------
#
#   §6
#
# Request       Initial   If no     Notes   Explanation
#  form          value    argument
#
# .ti ±N        -         ignored   B,E,m   Temporary indent. The next output text line
#                                           will be indented a distance ±N with respect
#                                           to the current indent. The resulting total
#                                           indent may be zero (equal to the current
#                                           page offset) but may not be less than the
#                                           current page offset. The temporary indent
#                                           applies only for the one output line
#                                           following the request; the value of the
#                                           current indent (that value stored in the
#                                           .i register) is not changed.
#
#  so an absolute position is relative to the page, and in html context needs to be
#  relative to the current indent. but a relative position (starts with ±) needs nothing.
#
#  looks like it's meant to cause a break too. mount_cachefs(1m) [SunOS 5.5.1]
#

module Troff
  def req_ti(indent = nil)
    return unless indent
    @current_block = blockproto
    @current_block.style.css[:margin_top] = '0'
    @document << @current_block
    temp_indent(to_u(indent.match(/^[-+]/) ? "#{indent}" : "#{indent}-#{@register['.i']}u", default_unit: 'm'))
  end

  def temp_indent(hang)
    apply { @current_block.style.css[:text_indent] = "#{to_em(hang.to_s)}em" }
  end
end
