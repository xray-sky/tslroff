# r.rb
# -------------
#   troff
# -------------
#
#   reverse (up) 1 em veritcal motion
#

module Troff
  def esc_r(*)
    esc_v %('-1m')
  end
end
