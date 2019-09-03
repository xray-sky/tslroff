# \".rb
# -------------
#   troff
# -------------
#
#   marks a comment line
#

module Troff
  def req_BsQuot(*args)
    apply do
      @current_block.type = :comment
      @current_block << args.join(' ')
    end
    apply { @current_block.type = :p }
  end
end