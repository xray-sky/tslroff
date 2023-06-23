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

  define_method 'req_\\"' do |argstr, breaking: nil|
    return nil unless argstr
    # This was done as a block, but then it was breaking up a block it was encountered during. So now it's inline.
    # REVIEW re-implement as an inline-block type? would that help us keep this open to capture multiple lines of comments in a single Comment object?
    apply { @current_block.terminal_text_style[:comment] = true }
    @current_block << argstr
    apply { @current_block.terminal_text_style.delete(:comment) }
  end

  define_method 'esc_"' do |s|
    send 'req_\\"', s[1..-1]
    ''
  end

end
