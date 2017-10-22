# e.rb
# -------------
#   troff
# -------------
#
#   definition of the \e (escape character) escape
#

module Troff

  def esc_e(s)
    @current_block << @state[:escape_char]
    s.sub(/^e/, '')
  end

end
