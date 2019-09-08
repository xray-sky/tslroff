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

module Troff
  def req_TP(width = nil)
    # TODO: see PP.rb for style carryover note
    @document << @current_block
    if width
      # divert the width; don't let it get into the output stream.
      @current_block = Block.new(type: :bare)
      unescape(width)
      width = @current_block.text.pop.text.strip	# TODO: actually use the width
    end
    @current_block = Block.new(type: :tp, style: @document.last.style.dup)

    # the tag may be styled
    hold_block = @current_block
    @current_block.style[:tag] = Block.new(type: :bare)
    @current_block = @current_block.style[:tag]
    @lines.collect_through do |l|
      @state[:register]['.c'].value += 1
      parse(l.rstrip)
      !@current_block.empty?
    end
    @current_block = hold_block
  end
end
