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
    ns = case s[1]
         when '(' then s[2..3]
         else          s[1]
         end
    ds = @state[:named_string][ns].to_s
    warn "unselected named string #{ns} from #{s.inspect}" if ds.empty?
    ds + s[2*(ns.length)..-1].to_s	# tricky - one char ns removes *x
                             	  	#          two char ns removes *(xx
                             	  	#          to_s covers us in case nothing's left
  end
end
