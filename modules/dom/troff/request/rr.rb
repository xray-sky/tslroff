# rr.rb
# -------------
#   troff
# -------------
#
#   remove numeric register
#
#   §8
#
# Request  Initial  If no     Notes   Explanation
#  form     value   argument
#
#  .rr R     -      ignored   -       Remove register R. If many registers are being 
#                                     created dynamically, it may become necessary to
#                                     remove unneeded registers to recapture internal
#                                     storage space for new registers.
#

module Troff

  def req_rr(reg)
    return if reg.nil? or reg.empty?
    @state[:registers].delete(reg)
  end

end