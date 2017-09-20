# PP.rb
# -------------
#   troff
# -------------
#
#   marks the end of a paragraph
#

module Troff

  def req_P ( args )
    req_PP args
  end

  def req_PP ( args )
    @current_block.style!(:p)
  end

end