# \".rb
# -------------
#   troff
# -------------
#
#   marks a comment line
#

module Troff

  def req_BsQuot ( args )
    self.apply {
      @current_block.type = :comment
      @current_block << args.join(" ") + "\n" 
    }
  end

end

