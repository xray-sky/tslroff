# (.rb
# -------------
#   troff
# -------------
#
#   basic definitions of the \* (named string) escape
#
#  the string could contain escapes that need further processing
#          e.g. '.dsS \s\n()S'
#    so we send back the expanded string, so that it might be unescaped
#
#  TODO: align this implementation with \n
#

module Troff
  def esc_star(s)
    s.slice!(0) if s.start_with?('(')
    @state[:named_string][s] || ''.tap { warn "undefined named string #{s}" }
  end
end
