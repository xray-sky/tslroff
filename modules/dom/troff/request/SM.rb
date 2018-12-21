# SM.rb
# -------------
#   troff
# -------------
#
#   smaller text
#

module Troff
  def req_SM(args)
    @state[:register]['.s'].value = Font.defaultsize - 1
    apply do
      @current_block.text.last.font.size = @state[:register]['.s'].value
      args.any? ? unescape(args.join(' ')) : parse(@lines.next)
    end
    @state[:register]['.s'].value = Font.defaultsize
    apply { @current_block.text.last.font.size = @state[:register]['.s'].value }
  end
end
