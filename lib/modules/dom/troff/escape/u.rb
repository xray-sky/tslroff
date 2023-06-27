# u.rb
# -------------
#   troff
# -------------
#
#   reverse (up) 1/2 em vertical motion
#

module Troff
  def esc_u(*)
    esc_v %('-0.5m')
  end
end
