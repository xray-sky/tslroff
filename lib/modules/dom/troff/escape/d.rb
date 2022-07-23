# d.rb
# -------------
#   troff
# -------------
#
#   forward (down) 1/2 em veritcal motion
#

module Troff
  def esc_d(s)
    esc_v %('0.5m')
  end
end
