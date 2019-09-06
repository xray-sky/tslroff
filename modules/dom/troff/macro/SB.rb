# SB.rb
# -------------
#   troff
# -------------
#
#   smaller text, bold
#

module Troff
  def req_SB(*args)
    apply do
      @current_block.text.last.font.size = Font.defaultsize - 1
      @current_block.text.last.font.face = :bold
      args = @lines.collect_through do |l|
               @state[:register]['.c'].value += 1
               Troff.req?(l) ? ( parse(l.rstrip) ; nil ) : l
             end.last.split unless args.any?
      unescape(args.join(' '))
    end
    apply { @current_block.text.last.font.size = Font.defaultsize }
  end
end
