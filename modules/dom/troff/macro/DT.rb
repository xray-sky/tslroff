# DT.rb
# -------------
#   troff
# -------------
#
#   .DT
#
#     Restore default tab settings (every 7.2en in troff(1), 5en in nroff(1))
#

module Troff
  def req_DT
    req_ta('.5i', '1i', '1.5i', '2i', '2.5i', '3i', '3.5i', '4i', '4.5i', '5i', '5.5i', '6i', '6.5i')
  end
end
