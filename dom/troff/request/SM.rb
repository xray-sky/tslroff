# SM.rb
# -------------
#   troff
# -------------
#
#   smaller text
#

module Troff

  def req_SM(args)
    apply do
      @current_block.text.last.font.size = Font.defaultsize - 1
      args.any? ? unescape(args.join(' ')) : parse(@lines.next)
    end
    apply { @current_block.text.last.font.size = Font.defaultsize }
  end

end
