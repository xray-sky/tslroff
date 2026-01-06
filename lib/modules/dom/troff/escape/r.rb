# r.rb
# -------------
#   troff
# -------------
#
#   reverse (up) 1 em veritcal motion
#

class Troff
  def esc_r(*)
    esc_v %('-1m')
  end
end
