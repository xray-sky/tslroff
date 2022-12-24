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

  def req_rr(argstr = '', breaking: nil)
    return nil if argstr.empty?
    reg = reqstr.slice(0, 2).strip
    @register.delete(reg)
  end

end
