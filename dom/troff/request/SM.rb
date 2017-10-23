# SM.rb
# -------------
#   troff
# -------------
#
#   smaller text
#

module Troff

  def req_SM(args)
    args.any? or args = [@lines.next]
    apply do
      @current_block.text.last.font.size = Font.defaultsize - 1
      unescape(args.join(' '))
    end
    apply { @current_block.text.last.font.size = Font.defaultsize }
  end

end
