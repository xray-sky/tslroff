# TH.rb
# -------------
#   troff
# -------------
#
#   Marks a "three-part header" 
#

module Troff

  def req_TH ( args )
    @current_block.style!(:th)
    @current_block << args.join(" ")
    @blocks << @current_block
    @current_block = StyledObject.new
  end

end