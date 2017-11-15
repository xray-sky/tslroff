# SB.rb
# -------------
#   troff
# -------------
#
#   smaller text, bold
#

module Troff
  def req_SB(args)
    apply do
      @current_block.text.last.font.size = Font.defaultsize - 1
      @current_block.text.last.font.face = :bold
      args.any? ? unescape(args.join(' ')) : parse(@lines.next)
    end
    apply { @current_block.text.last.font.size = Font.defaultsize }
  end
end
