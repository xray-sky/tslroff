# frozen_string_literal: true
#
# tm.rb
# -------------
#   troff
# -------------
#
#   §20.2
#

class Troff
  # Request  Initial  If no     Notes   Explanation
  #  form     value   argument
  #
  # .tm string -      newline     -     Print string on terminal (UNIX standard message
  #                                     output).

  def tm(argstr = '', breaking: nil)
    warn(".tm: #{argstr}")
  end
end
