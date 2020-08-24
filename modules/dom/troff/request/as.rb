# as.rb
# -------------
#   troff
# -------------
#
#   §7.5
#
# Request       Initial   If no     Notes   Explanation
#  form          value    argument
#
# .as xx string  ignored  -         -       Append string to xx (append version of .ds)
#
#

module Troff
  def req_as(name, *args)
    @state[:named_string][name] << unescape(args.join(' ').sub(/^"/, ''), :copymode => true)
  end
end
