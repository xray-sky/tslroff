# TE.rb
# -------------
#   troff
# -------------
#
#   Ends table (tbl) processing
#

module Troff
  def req_TE(_args)
    @current_block = Block.new(style: @current_block.style.dup)
    @document << @current_block
  end
end