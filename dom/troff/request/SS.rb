# SS.rb
# -------------
#   troff
# -------------
#
#   Marks a subsection header
#

module Troff

  def req_SS(args)
    apply do
      @current_block.type = :ss
      @current_block << args.join(' ')
    end
    @blocks << @current_block
    @current_block = Block.new(type: :tp, style: @current_block.style.dup)  # TODO: see PP.rb for style carryover note
  end

end