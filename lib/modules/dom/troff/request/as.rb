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
# .as can be used on a string that doesn't already exist.
# Undefined strings (or ones that have been .rm'ed) output as blank.
#
#
# REVIEW might get into trouble somewhere with args.join vs. preventing argparse
#

module Troff
  def req_as(name, *args)
    @state[:named_string][name] ||= String.new
    @state[:named_string][name] << unescape(args.join(' ').sub(/^"/, ''), :copymode => true)
    #warn "appended to named string #{name.inspect}: #{@state[:named_string][name].inspect}"
  end
end
