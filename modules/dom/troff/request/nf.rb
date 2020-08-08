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
    req_br unless broke?
    req_br # is this too many? I'm trying to make up for a <br> at the end
           # of a <p> which the browser disappears, followed immediately by a .nf
           # which makes the next .PP have margin-top:0. (see a.out(5) [AOS 4.3])
           # in the meanwhile I'd rather have one extra than none at all
    @register['.u'].value = 0
  end
end
