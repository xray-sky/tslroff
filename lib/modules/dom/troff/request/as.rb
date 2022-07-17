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
# REVIEW ideal(1) [AOS-4.3] suggests .as can be used on a string that doesn't already exist.
#                           or that .rm doesn't remove it, but defines it as blank
#

module Troff
  def req_as(name, *args)
    @state[:named_string][name] ||= String.new
    @state[:named_string][name] << unescape(args.join(' ').sub(/^"/, ''), :copymode => true)
  end
end
