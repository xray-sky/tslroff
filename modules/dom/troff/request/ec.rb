# ec.rb
# -------------
#   troff
# -------------
#
#   §10.1
#
# Request       Initial   If no     Notes   Explanation
#  form          value    argument
#
# .ec c         \         \         -       Set escape character to \, or to c, if given.
#

module Troff
  def req_ec(char = '\\')
    @state[:escape_char] = char
  end

  def xinit_ec
    req_ec
    true
  end
end
