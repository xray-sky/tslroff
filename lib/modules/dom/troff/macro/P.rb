# P.rb
# -------------
#   troff
# -------------
#
#   .P
#
#     Begin a paragraph with normal font, point size, and indent. .PP is a synonym for
#     mm(5) macro .P
#
#  REVIEW this is interacting with .in, not resetting that indent. correct? mkfs(1m) [GL2-W2.5]
#         it's also causing margin_top to collapse to 0 - bfs(1) [GL2-W2.5]
#

module Troff
  def req_P(*_args)
    warn "received argument #{_args.inspect} to .P - why??" unless _args.empty?
    init_IP		# .PP resets \n()I to 0.5i
    @current_block = blockproto
    @document << @current_block
    indent(@state[:base_indent] + @register[')R'])
  end

  alias req_PP req_P
end
