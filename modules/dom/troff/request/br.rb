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
# REVIEW: the intersection of all these things needs closer look; on the AOS pages
#         there are lots of examples like adb(1), or bitprt(1) [ AOS 4.3 ]:
#           .nf
#              something
#           .br
#              something else
#           .br
#              third thing
#           .fi
#         where this is output with no extra space between any of the three lines.
#

module Troff
  def req_br
    unless nofill? and !broke?	# REVIEW I think in nofill mode a .br makes nothing happen, because there's no line to output?
      @current_block << LineBreak.new
      @current_tabstop = @current_block.text.last
      @current_tabstop[:tab_stop] = 0
    end
  end
end
