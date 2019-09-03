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

module Troff
  def req_nf
    @state[:register]['.u'].value = 0
  end
end