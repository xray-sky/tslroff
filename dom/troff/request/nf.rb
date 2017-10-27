# nf.rb
# -------------
#   troff
# -------------
#
#   set no-fill mode (break at end of input line)
#
# TODO: \c will continue an unfilled output line with the next encountered 
#       input line. (§4.2)
#

module Troff
  def req_nf(_args)
    @state[:fill] = false
  end
end