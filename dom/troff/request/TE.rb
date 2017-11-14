# TE.rb
# -------------
#   troff
# -------------
#
#   Ends table (tbl) processing
#

module Troff
  def req_TE(args)
    @current_block = Block.new(style: @current_block.style.dup)
  end
end