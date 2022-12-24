# ad.rb
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
# .ad c    adj,both adjust    E       Line adjustment is begun. If fill mode is not on,
#                                     adjustment will be deferred until fill mode is back
#                                     on. If the type indicator c is present, the adjustment
#                                     type is changed as shown in the following table.
#
#                                     Indicator  |         Adjust Type
#                                     -----------------------------------------
#                                        l       |  adjust left margin only
#                                        r       |  adjust right margin only
#                                        c       |  center
#                                     b or n     |  adjust both margins
#                                     absent     |  unchanged
#
#                                     The adjustment type indicator c may also be a number
#                                     obtained from the .j register. (See section 25 in
#                                     the "Summary," "Predefined Read-Only Registers.")
#
# [ :left, :both, nil, :center, nil, :right ]
#
#  REVIEW proper interaction with fill mode
#

module Troff
  def req_na(_argstr = '', breaking: nil)
    @state[:adjust] = false
    # REVIEW this should keep .P followed by .na from collapsing margin_top
    if !nofill? and @current_block.immutable?
      @current_block = blockproto
      @current_block.style.css[:margin_top] = 0
      @document << @current_block
    end
  end

  def req_ad(argstr = '', breaking: nil)
    init_ad
    adj = argstr.split.first
    return nil unless adj
    @register['.j'].value = case adj
                            when /^[0135]$/ then adj
                            when 'l'        then 0
                            when 'r'        then 5
                            when 'c'        then 3
                            when 'b', 'n'   then 1
                            else
                              warn "trying to adjust nonsense #{adj.inspect}"
                            end
    if !nofill? and @current_block.immutable?
      @current_block = blockproto
      @current_block.style.css[:margin_top] = 0
      @document << @current_block
    end
  end

  def init_ad
    @state[:adjust] = true
  end
end
