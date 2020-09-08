# e.rb
# -------------
#   troff
# -------------
#
#   definition of the \e (escape character) escape
#

module Troff
  def esc_e(s)
    @current_block << @state[:escape_char].dup	# don't push a reference to the escape character, or you'll start modifying it with <<!
    s.sub(/^e/, '')
  end
end
