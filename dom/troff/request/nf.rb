# nf.rb
# -------------
#   troff
# -------------
#
#   set no-fill mode (break at end of input line)
#

module Troff
  def req_nf(_args)
    @state[:fill] = false
  end
end