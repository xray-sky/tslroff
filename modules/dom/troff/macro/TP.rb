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

module Troff
  def req_TP(args)	# TODO: incomplete; needs to accept width args
    warn "TP #{args.inspect}"
    width = parse(args[0]) if args.any?
    warn "=> TP #{width.inspect}"
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