# SH.rb
# -------------
#   troff
# -------------
#
#   Marks a normal section header
#

module Troff
  def req_SH(*args)
    apply do
      @current_block.type = :sh
      @current_block << args.join(' ')
    end
    @document << @current_block
    @current_block = Block.new(style: Style.new(section: args.join(' ')))
  end
end