# ie.rb
# -------------
#   troff
# -------------
#
#   conditional acceptance of input
#
#   §16
#
# Request       Initial   If no     Notes   Explanation
#  form          value    argument
#
# .ie c anything   -       -         u      If portion of if-else; all above forms (like .if).
#

module Troff
  def req_ie(*args)
    @state[:else] = !req_if(*args)
  end
end
