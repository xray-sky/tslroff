# PP.rb
# -------------
#   troff
# -------------
#
#   marks the end of a paragraph
#

module Troff
  def req_PP(*_args)
    @document << @current_block
    # REVIEW: copying the style is meant to continue the section marker, 
    # for .synopsis, etc. is this approach going to make a mess?
    @current_block = Block.new(style: @current_block.style.dup)
  end

  alias req_P  req_PP
  alias req_LP req_PP
end