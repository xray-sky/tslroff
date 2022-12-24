# tm.rb
# -------------
#   troff
# -------------
#
#   §20.2
#
# Request  Initial  If no     Notes   Explanation
#  form     value   argument
#
# .tm string -      newline     -     Print string on terminal (UNIX standard message
#                                     output).
#

module Troff
  def req_tm(argstr = '', breaking: nil)
    warn(".tm: #{argstr}")
  end
end
