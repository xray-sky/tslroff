# z.rb
# -------------
#   troff
# -------------
#
#   definition of the \z (non-spacing) escape
#
#

module Troff
  def esc_z(s)
    warn "\\z trying to output #{s.inspect} as non-spacing character"
    unescape(s)
  end
end
