# PP.rb
# -------------
#   troff
# -------------
#
#   marks the end of a paragraph
#

module Troff

  def req_PP ( args )
    #puts "PP: (new) -- #{args.inspect}"
    @blocks << @current_block
    @current_block = StyledObject.new
  end

end