# \".rb
# -------------
#   troff
# -------------
#
#   marks a comment line
#
# TODO as a block, this is breaking up blocks that oughtn't be broke!
#      better but maybe with unwanted whitespace. REVIEW.
#

module Troff
  def req_BsQuot(*args)
    #apply do
    #  @current_block.type = :comment
    #  @current_block << args.join(' ')
    #end
    #apply { @current_block.type = :p }
    apply { @current_block.text.last.style[:comment] = true }
    @current_block << args.join(' ')
    apply { @current_block.text.last.style.delete(:comment) }
  end
end
