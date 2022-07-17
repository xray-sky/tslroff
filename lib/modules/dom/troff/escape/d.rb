# d.rb
# -------------
#   troff
# -------------
#
#   forward (down) 1/2 em veritcal motion
#

module Troff
  def esc_d(s)
    #warn "not yet tokenized - #{__callee__}"
    esc_v %('0.5m')
    #s.slice!(0)
    #''
  end
end
