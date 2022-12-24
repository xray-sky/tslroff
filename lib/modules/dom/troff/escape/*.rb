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
  define_method 'esc_*' do |s|
    s.slice!(0) if s.start_with?('(')
    s = __unesc_star(__unesc_n(s))
    @state[:named_string][s] || ''.tap { warn "undefined named string #{s}" }
  end
end
