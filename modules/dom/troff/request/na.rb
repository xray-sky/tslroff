# na.rb
# -------------
#   troff
# -------------
#
#   §4.2
#
# Request  Initial  If no     Notes   Explanation
#  form     value   argument
#
# .na      adjust   -         E       No-adjust. Adjustment is turned off; the right
#                                     margin will be ragged. The adjustment type for .ad
#                                     is not changed. Output line filling still occurs if
#                                     fill mode is on.
#

module Troff
  def req_na
    @state[:adjust] = false
    # REVIEW this should keep .P followed by .na from collapsing margin_top
    if !nofill? and @current_block.immutable?
      case @current_block.type
      when :p  then req_P
      when :dl then req_IP('')
      else warn "trying to do .na in unexpected context (#{@current_block.type.inspect})"
      end
      @current_block.style[:margin_top] = 0
    end
  end
end
