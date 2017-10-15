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
    @blocks << @current_block
    @current_block = Block.new
  end

end