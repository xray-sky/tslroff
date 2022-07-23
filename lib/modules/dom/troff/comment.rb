# Comments (troff)
#
#   §10.7
#
#   Comments may be embedded at the end of any line by prefacing them with \".
#   The new-line at the end of a comment cannot be concealed.
#
#   A line beginning with \" will appear as a blank line and behave like .sp 1. (TODO)
#

module Troff

  def req_BsQuot(*args)
    # This was done as a block, but then it was breaking up a block it was
    # encountered during. So now it's inline.
    apply { @current_block.text.last.style[:comment] = true }
    @current_block << args.join
    apply { @current_block.text.last.style.delete(:comment) }
    # and this was interfering with comments inserted between .TP macro and tag - ex(1) [SunOS 5.5.1]
    @current_block.reset_output_indicator
  end

  def esc_quot(s)
    req_BsQuot(s[1..-1])
    ''
  end

end
