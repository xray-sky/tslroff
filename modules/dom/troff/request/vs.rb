# vs.rb
# -------------
#   troff
# -------------
#
#   §5
#
# Request  Initial  If no     Notes   Explanation
#  form     value   argument
#
# .vs N  1/6in;12pt previous  E,p     Vertical base line spacing (V).
#

module Troff
  def req_vs(*height)
    warn "don't know how to .vs #{height.inspect}"
  end
end
