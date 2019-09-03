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
# TODO: what does ".TP &" mean? (see: machid.1 [GL2-W2.5])
#
# FIXME: rendering context (current_block) - size is going into the output stream
#

module Troff
  def req_TP(width = nil)
    if width
      parse(width) 
      width = @current_block.text.last.text.strip	# TODO: actually use the width
      @current_block.text.pop			# REVIEW: side effects?
    end
    @document << @current_block
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