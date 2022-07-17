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
      @current_block = blockproto
      @current_block.style.css[:margin_top] = 0
      @document << @current_block
    end
  end
end
