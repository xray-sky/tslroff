# eo.rb
# -------------
#   troff
# -------------
#
#   §10.1
#
# Request       Initial   If no     Notes   Explanation
#  form          value    argument
#
# .eo           on         -         -       Turn escape mechanism off.
#

module Troff
  def req_eo
    warn "disabling escape mechanism"
    @state[:escape_char] = nil
    true
  end
end
