# ds.rb
# -------------
#   troff
# -------------
#
#   §7.5
#
# Request       Initial   If no     Notes   Explanation
#  form          value    argument
#
# .ds xx string  ignored  -         -       Define a string 'xx' containing 'string'.
#                                           Any initial double-quote in 'string' is
#                                           stripped off to permit initial blanks.
#
#

module Troff
  def req_ds(name, *args)
    @state[:named_string][name] = unescape(args.join(' ').sub(/^"/, ''), :copymode => true)
  end

  def init_ds
    @state[:named_string] = {
      '.T' => 'html'   # name of output device
    }
    true
  end
end