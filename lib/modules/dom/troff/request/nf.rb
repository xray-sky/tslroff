# nf.rb
# -------------
#   troff
# -------------
#
#   §4.2
#
# Request  Initial  If no     Notes   Explanation
#  form     value   argument
#
# .nf      fill on  -         B,E     No-fill. Subsequent output lines are neither filled
#                                     nor adjusted. Input text lines are copied directly
#                                     to output text lines without regard for the current
#                                     line length.
#
# TODO: §4.2 The copying of an input line in no-fill mode can be interrupted by
#            terminating the partial line with a '\c'. The next encountered input
#            text line will be considered to be a continuation of the same line of input
#            text. If the intervening control lines cause a break, any partial line will
#            be forced out along with any partial word.
#
# REVIEW all the edge cases
#        .PP followed by .nf shouldn't margin_top: 0 -- ascii(5) [GL2-W2.5]
#        .br followed by .nf; the browser swallows the <br /> before the </p>, and
#            we get an incorrect margin_top:0 on the next <p>? -- a.out(5) [AOS 4.3]

module Troff
  def req_nf
    @register['.u'].value = 0
    # do we need to break? or is this already a brand new block.
    if @current_block.immutable?
      @current_block = blockproto
      @current_block.style.css[:margin_top] = 0
      @document << @current_block
    end
  end
end
