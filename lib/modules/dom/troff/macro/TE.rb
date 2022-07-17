# TE.rb
# -------------
#   troff
# -------------
#
#   Ends table (tbl) processing
#

module Troff
  def req_TE
    @current_block = blockproto
    @document << @current_block
  end
end
