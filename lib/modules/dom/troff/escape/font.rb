# frozen_string_literal: true
#
# defs.rb
# -------------
#   troff
# -------------
#
#   \f - font
#   \s - font size
#

class Troff
  # alias :esc_s :ps  <==  q.v. request/fonts.rb

  def esc_f(argstr = '')
    ft argstr.start_with?('(') ? argstr[1..2] : argstr[0]
  end
end
