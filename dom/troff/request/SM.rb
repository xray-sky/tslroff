# SM.rb
# -------------
#   troff
# -------------
#
#   smaller text
#

module Troff
  def req_SM(args)
    @state[:register]['.s'] = Font.defaultsize - 1
    apply do
      @current_block.text.last.font.size = @state[:register]['.s']
      args.any? ? unescape(args.join(' ')) : parse(@lines.next)
    end
    @state[:register]['.s'] = Font.defaultsize
    apply { @current_block.text.last.font.size = @state[:register]['.s'] }
  end
end
