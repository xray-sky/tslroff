# el.rb
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
# .el anything  -       -           -      Else portion of if-else.
#

module Troff
  def req_el(*args)
    return '' unless @state[:else]
    resc = Regexp.quote(@state[:escape_char])
    argstr = args.shift.strip
    if argstr.sub!(/^#{resc}{/, '')
      loop do
        parse(argstr)
        argstr = next_line
        break if argstr.sub!(/#{resc}}$/, '')
      end
    end
    parse(argstr)
  end
end
