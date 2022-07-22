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
=begin
    ns = case s[1]
         when '(' then s[2..3]
         else          s[1]
         end
    ds = @state[:named_string][ns].to_s
    warn "unselected named string #{ns} from #{s.inspect}" if ds.empty?
    ds + s[2*(ns.length)..-1].to_s	# tricky - one char ns removes *x
                             	  	#          two char ns removes *(xx
                             	  	#          to_s covers us in case nothing's left
=end
#    ns = get_def_str(s[1..-1])
#warn "esc_star ns == #{ns.inspect} (from #{s.inspect})"
#    ns.slice!(0) if ns.start_with?('(')
    s.slice!(0) if s.start_with?('(')
#    @state[:named_string][ns] || ''.tap { warn "undefined named string #{ns}" }
#    @state[:named_string][s] || ''.tap { warn "undefined named string #{s}" } # TODO: no (see below)
    # returned named string might include escapes that need processed before copy
    # REVIEW: did this because of cw(1) [GL2-W2.5] - but is it _ALWAYS CORRECT_ to unescape it??
    # REVIEW: I think so, because we read the string in .ds with copymode
    #warn "\\* processing #{@state[:named_string][s].inspect}"
    #unescape(@state[:named_string][s] || ''.tap { warn "undefined named string #{s}" })
    #''
    @state[:named_string][s] || ''.tap { warn "undefined named string #{s}" }
  end
end
