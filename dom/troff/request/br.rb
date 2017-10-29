# br.rb
# -------------
#   troff
# -------------
#
#   §4.2
#
# Request  Initial  If no     Notes   Explanation
#  form     value   argument
#
# .br      -        -         B       Break. The filling of the line currently being
#                                     collected is stopped and the line is output without
#                                     adjustment. Text lines beginning with space
#                                     characters and empty text lines (blank lines) also
#                                     cause a break.
#

module Troff
  def req_br(_args)
    # REVIEW: does this need to be more sophisticated??
    @current_block << '&troff_br;'
  end
end