# TH.rb
# -------------
#   troff
# -------------
#
#   Marks a "three-part header" 
#

module Troff

  def req_TH ( args )
    begin
      @current_block.style!(:th)
      @current_block << args
      @blocks << @current_block
      @current_block = StyledObject.new
    rescue ImmutableStyleError
      @blocks << @current_block
      @current_block = StyledObject.new
      retry
    end
  end

end