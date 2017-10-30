# tr.rb
# -------------
#   troff
# -------------
#
#   §10.5
#
# Request      Initial   If no     Notes   Explanation
#  form         value    argument
#
# .tr abcd...  none     -          O       Translate 'a' into 'b', 'c' into 'd', etc.
#                                          If an odd number of characters is given, the
#                                          last one will be mapped into the space 
#                                          character. To be consistent, a particular
#                                          translation must stay in effect from input to 
#                                          output time. To reset '.tr', follow request
#                                          with previous arguments given in duplicate.
#                                          The example given at the start of this entry,
#                                          for instance, would be turned off as follows:
#                                          '.tr aacc'.
#
# Unfortunately this is not a strict one-to-one arrangement. Constructs like \& and \(**
# are allowed for the substituted "character".

module Troff
  def req_tr(args)
    #TODO: this.
  end
end