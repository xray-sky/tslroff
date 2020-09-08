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

module Troff
  def req_ti(indent = nil)
    return unless indent
    @current_block = blockproto
    @current_block.style.css[:margin_top] = '0'
    @document << @current_block
    temp_indent(to_u(indent, default_unit: 'm')) # TODO this actually has to become negative, for css. but what to subtract it from?? sendmail(1m) [GL2-W2.5]
  end

  def temp_indent(hang)
    apply { @current_block.style.css[:text_indent] = "#{to_em(hang.to_s)}em" }
  end
end
