# rs.rb
# -------------
#   troff
# -------------
#
#   §5.3
#
# Request  Initial  If no     Notes   Explanation
#  form     value   argument
#
# .rs      space    -         D       Restore spacing. The no-space mode is turned off.
#

module Troff
  def req_rs
    @state.delete(:nospace)
  end
end
