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

module Troff
  def req_P
    init_IP		# .PP resets \n()I to 0.5i
    @current_block = blockproto
    @document << @current_block
  end

  alias req_PP req_P
  alias req_LP req_PP	# TODO: move this to whatever system defines it; it's not SysV [ gl2-w2.5 ]
end
