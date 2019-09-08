# SH.rb
# -------------
#   troff
# -------------
#
#   Marks a normal section header
#

module Troff
  def req_SH(*args)
    text = args.join(' ')
    apply do
      @current_block.type = :sh
      @current_block << text
    end
    @document << @current_block
    @current_block = Block.new(style: Style.new({ :section => text }, Kernel.const_get('ImmutableBlockError')))
  end
end
