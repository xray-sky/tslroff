# B.rb
# -------------
#   troff
# -------------
#
#   applies BOLD type
#

module Troff

  def req_B ( args )
    @current_block.append(StyledObject.new(args,:bold))
  end

end