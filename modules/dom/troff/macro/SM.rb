# SM.rb
# -------------
#   troff
# -------------
#
#   smaller text
#

module Troff
  def req_SM(*args)
    @state[:register]['.s'].value = Font.defaultsize - 1
    apply do
      @current_block.text.last.font.size = @state[:register]['.s'].value
      args = @lines.collect_through do |l|
               @state[:register]['.c'].value += 1
               Troff.req?(l) ? ( parse(l.rstrip) ; nil ) : l
             end.last.split unless args.any?
      unescape(args.join(' '))
    end
    @state[:register]['.s'].value = Font.defaultsize
    apply { @current_block.text.last.font.size = @state[:register]['.s'].value }
  end
end
