# TP.rb
# -------------
#   troff
# -------------
#
#   .TP in
#
#     Begin indented paragraph with hanging tag. The next line that contains text to be
#     printed is taken as the tag. If the tag does not fit, it is printed on a separate
#     line.
#
#   .TP (width)
#   (tag)
#   text...
#
# TODO: what does ".TP &" mean? (see: machid.1 [GL2-W2.5])
# TODO: tabs interacting with indents?
#

module Troff
  def req_TP(indent = nil)
    indent = nil if indent == '&'	# TODO: ???
    req_it('1', :finalize_TP, indent)
    @current_block = Block.new(type: :bare)
    @current_tabstop = @current_block.text.last
    @current_tabstop[:tab_stop] = 0
  end

  def finalize_TP(indent)
    tag = @current_block.text
    @current_block = @document.last
    req_IP(tag, indent)
  end
end
