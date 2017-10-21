# SH.rb
# -------------
#   troff
# -------------
#
#   Marks a normal section header
#

module Troff

  def req_SH(args)
    apply do
      @current_block.type = :sh
      @current_block << args.join(' ')
      @blocks << @current_block
      @current_block = Block.new
    end
  end

end