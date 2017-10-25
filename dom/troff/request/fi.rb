# fi.rb
# -------------
#   troff
# -------------
#
#   set no-fill mode (break at end of input line)
#

module Troff
  def req_fi(_args)
    @state[:fill] = true
  end
end