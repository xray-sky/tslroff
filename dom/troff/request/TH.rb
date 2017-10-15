# TH.rb
# -------------
#   troff
# -------------
#
#   Marks a "three-part header" 
#

module Troff

  def req_TH ( args )
    @current_block.type = :th
    @current_block << args.join(" ")
    @blocks << @current_block
    @current_block = Block.new
  end

end