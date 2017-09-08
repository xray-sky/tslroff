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
    #puts "PP: (new) -- #{args.inspect}"
    #@blocks << @current_block
    #@current_block = StyledObject.new
    begin
      @current_block.style!(:p)
    rescue ImmutableStyleError
      @blocks << @current_block
      @current_block = StyledObject.new
      retry
    end
  end

end