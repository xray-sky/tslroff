# TP.rb
# -------------
#   troff
# -------------
#
#   Titled paragraph
#

module Troff

  def held_TP ( tag )
    @current_block.style[:tag] = tag
  end

  def req_TP ( args )	# TODO incomplete; needs to accept width args
    @blocks << @current_block
    @current_block = Block.new(:type => :tp)
    @hold = [ "TP", 1 ]
  end

end