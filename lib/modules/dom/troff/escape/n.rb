# n.rb
# -------------
#   troff
# -------------
#
#   number registers
#
#   appears as though an otherwise uninitialized register has a value of 0
#

module Troff
  def esc_n(s)
    #nr = get_def_str(s[1..-1])
    incr = s.slice!(0) if s =~ /^[-+]/
    s.slice!(0) if s.start_with?('(')
    # I think we can get away with relying on the @register default value
    # but let's keep the diagnostic for now.
    warn "unselected number register #{s} - using 0" unless @register.has_key?(s)
    @register[s].send(incr) if incr
    @register[s].to_s
  end
end
