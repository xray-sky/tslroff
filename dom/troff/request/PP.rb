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
    @current_block = Block.new
  end

  alias req_P req_PP

end