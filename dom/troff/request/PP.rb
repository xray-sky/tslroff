# PP.rb
# -------------
#   troff
# -------------
#
#   marks the end of a paragraph
#

module Troff

  def req_PP(*)
    @blocks << @current_block
    @current_block = Block.new(style: @current_block.style.dup)  # TODO: copying the style is meant to continue the section marker, for .synopsis, etc. is this approach going to make a mess?
  end

  alias req_P  req_PP
  alias req_LP req_PP

end