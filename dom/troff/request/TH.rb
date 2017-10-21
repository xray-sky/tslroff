# TH.rb
# -------------
#   troff
# -------------
#
#   Marks a "three-part header" 
# TODO this is totally wrong
#

module Troff

  def req_TH(args)
    apply do
      @current_block.type = :th
      @current_block << args.join(' ')
      @blocks << @current_block
      @current_block = Block.new 
    end
  end

end