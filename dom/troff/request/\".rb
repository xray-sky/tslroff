# \".rb
# -------------
#   troff
# -------------
#
#   marks a comment line
#

module Troff

  def req_BsQuot ( args )
    puts "COMMENT: #{args.inspect}"
  end

end
