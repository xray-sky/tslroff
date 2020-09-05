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
    indent = to_u(indent, default_unit: 'm')
    if @current_block.immutable?
      case @current_block.type
      when :p  then req_P
      when :dl then req_IP('')
      else warn "trying to do .ti in unexpected context (#{@current_block.type.inspect})"
      end
      @current_block.style[:margin_top] = 0
    end
    @current_block.style.css[:text_indent] = "#{to_em(indent)}em"
  end
end
