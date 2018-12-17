# TE.rb
# -------------
#   troff
# -------------
#
#   Ends table (tbl) processing
#

module Troff
  def req_TE(_args)
  warn ".TE #{@current_block.type.inspect}"
  warn @blocks.last.text.inspect
    @current_block = Block.new(style: @current_block.style.dup)
  warn ".TE #{@current_block.type.inspect}"
  end
end