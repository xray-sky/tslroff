# PM.rb
# -------------
#   troff
# -------------
#
#   .PM m
#
#     Produces proprietary markings; see REFERENCE to mm(1).
#     REVIEW: not sure this is present in too many non-AT&T versions of tmac.an
#

module Troff
  def req_PM(*m)
    warn "don't know how to PM #{m.inspect}"
  end
end
