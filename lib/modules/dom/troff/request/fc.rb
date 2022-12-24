# fc.rb
# -------------
#   troff
# -------------
#
#   §9.2
#
# Request    Initial     If no     Notes   Explanation
#  form       value      argument
#
# .fc a b    off         off       -       The field delimiter is set to a; the padding
#                                          indicator is set to the space character or to
#                                          b, if given. In the absence of arguments the
#                                          field mechanism is turned off.
#                                          separated by spaces, and a value preceeded
#                                          by + is treated as an increment to the
#                                          previous stop value.
#
#  A field is contained between a pair of field delimiter characters, and consists of
#  sub-strings separated by padding indicator characters. The field length is the distance
#  on the input line from the position where the field begins to the next tab stop. The
#  difference between the total length of all sub-strings and the field length is
#  incorporated as horizontal padding space that is divided among the indicated padding
#  places. The incorporated padding is allowed to be negative. For example, if the field
#  delimiter is # and the padding indicator is ^, #^xxx^right# specifies a right-adjusted
#  string with the string xxx centered in the remaining space.
#
#  for now the only use I observed in the Manual is `.fc ^ ~`, with all padding on the
#  left. so it's something like a single tab, regardless of fit; troff seems to pile up
#  the output fields on overflow (like I would get with fixed-width tab spans in HTML anyway)
#
#  REVIEW what happens when you get a tab inside of a field? maybe it won't happen.
#

module Troff
  def req_fc(argstr = '', breaking: nil)
    delim = argstr.slice!(0) || ''
    pad = argstr.sub(/^ */, '').slice(0) || ' '
    pad = ' ' if pad.empty?
    if delim.empty?
      warn ".fc disabling field processing"
      @state.delete(:field_delimiter)
      @state.delete(:field_pad_char)
    else
      warn ".fc enabling field processing (#{delim.inspect} / #{pad.inspect})"
      @state[:field_delimiter] = delim
      @state[:field_pad_char]  = pad
    end
  end
end
