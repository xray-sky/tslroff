# ft.rb
# -------------
#   troff
# -------------
#
#   §2.3
#
# Request       Initial   If no     Notes   Explanation
#  form          value    argument
#
# .fp F         Roman     previous  E       Font changed to F. Alternatively, embed \fF.
#                                           The font name P is reserved to mean the
#                                           previous font.
#
# REVIEW does this need to track mounted fonts? does R always mean position 1 even if
#        something else is mounted there?
#

#module Troff
#end
