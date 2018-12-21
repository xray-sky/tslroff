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
    # TODO: see PP.rb for style carryover note
    @current_block = Block.new(type: :p, style: @current_block.style.dup)
  end
end