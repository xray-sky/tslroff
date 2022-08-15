# u.rb
# -------------
#   troff
# -------------
#
#   reverse (up) 1/2 em vertical motion
#

module Troff
  def esc_u(s)
    esc_v %('-0.5m')
  end
end
