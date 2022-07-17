# ps.rb
# -------------
#   troff
# -------------
#
#   §2.3
#
# Request       Initial   If no     Notes   Explanation
#  form          value    argument
#
# .ps ±N        10pt      previous  E       Point size set to ±N. Alternatively, embed
#                                           \sN or \s±N. Any positive size value may be
#                                           requested; if invalid, the nearest valid size
#                                           will result, with a maximum size to be
#                                           determined by the individual printing device.
#                                           A paired sequence +N, -N will work because the
#                                           previous value is also remembered.
#                                           Ignored in nroff.
#
#   our default font size is 12pt
#

#module Troff
#end
