# u.rb
# -------------
#   troff
# -------------
#
#   reverse (up) 1/2 em veritcal motion
#

module Troff
  def esc_u(s)
    #warn "not yet tokenized - #{__callee__}"
    esc_v %('-0.5m')
    #s.sub(/^u/, '')
  end
end
