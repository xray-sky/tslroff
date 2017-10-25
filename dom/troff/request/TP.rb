# TP.rb
# -------------
#   troff
# -------------
#
#   Titled paragraph
#
#   .TP (width)
#   (title)
#   text...
#

module Troff
  def req_TP(args)	# TODO: incomplete; needs to accept width args
    @blocks << @current_block
    # TODO: see PP.rb for style carryover note
    @current_block = Block.new(type: :tp, style: @current_block.style.dup)

    # the tag may be styled
    hold_block = @current_block
    @current_block.style[:tag] = Block.new(type: :bare)
    @current_block = @current_block.style.tag
    parse(@lines.next)
    @current_block = hold_block
  end
end