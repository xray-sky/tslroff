# ce.rb
# -------------
#   troff
# -------------
#
#   §4.2
#
# Request  Initial  If no     Notes   Explanation
#  form     value   argument
#
# .ce N     off     N=1       B,E     Center the next N input text lines within the
#                                     current (line-length minus indent). If N=0,
#                                     any residual count is cleared. A break occurs after
#                                     each of the N input lines. If the input line is too
#                                     long, it will be left adjusted.
#
#  TODO N=0
#

module Troff
  def req_ce(n = '1')
    n = n.to_i
    req_nf
    @current_block.style.css[:text_align] = 'center'
    req_it(n, :finalize_ce)
  end

  def finalize_ce
    req_fi
    @current_block.style.css.delete(:text_align)
  end
end
