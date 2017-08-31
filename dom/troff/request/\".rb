# \".rb
# -------------
#   troff
# -------------
#
#   marks a comment line
#

module Troff

  def req_BsQuot ( args )
    @blocks << @current_block
    @blocks << StyledObject.new(args, :comment)
    @current_block = StyledObject.new
    #args = "\n" if args.strip.empty?
    #@current_block.style!(:comment)
    #@current_block.append(args)
  end

end

