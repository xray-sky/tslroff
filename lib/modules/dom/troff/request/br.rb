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
# REVIEW  the intersection of all these things needs closer look; on the AOS pages
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
#         experiments with nroff on a terminal demonstrate that .br never inserts
#         space; it only breaks a line. so three consecutive .brs has the same effect
#         as one, and in nofill mode it has no effect at all.
#
#         also doesn't count for .it
#

module Troff
  def req_br(*_args)
    #warn "pointlessly received arguments to .br #{_args.inspect} -- why?" if _args.any?
    unless nofill? or broke?
      @current_block << LineBreak.new(font: @current_block.text.last.font.dup,
                                     style: @current_block.text.last.style.dup)
      #@current_tabstop = @current_block.text.last
    end
  end
end
