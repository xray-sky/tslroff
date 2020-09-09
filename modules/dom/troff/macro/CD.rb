# CD.rb
# -------------
#   troff
# -------------
#
#   .CD
#
#     define delimiters for cw(1) processing
#
#  TODO everything
#

module Troff
  def req_CD(*)
    warn "requires preprocessing by cw(1)"
  end
end
