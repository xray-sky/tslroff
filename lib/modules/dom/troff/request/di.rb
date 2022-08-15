# di.rb
# -------------
#   troff
# -------------
#
#   §7.5
#
# Request       Initial   If no     Notes   Explanation
#  form          value    argument
#
# .di xx         -        end       D       Divert output to macro xx.
#                                           Normal text processing occurs during diversion
#                                           except that page offsetting is not done. The
#                                           diversion ends when the request .di or .da is
#                                           encountered without an argument; extraneous requests
#                                           of this type should not appear when nested diversions
#                                           are being used.
#
# there is also .da, the append verison of .di
#

module Troff
  def req_di(macro = nil, *args)
    if macro
      warn ".di creating diversion #{macro.inspect}"
      @state[:diversion_stack] << @current_block
      @current_block = blockproto
      @state[:diversions][macro] = [ @current_block ]
      define_singleton_method "req_#{Troff.quote_method macro}" do |*args|
        warn "inserting diversion #{macro.inspect}"
        @document << @state[:diversions][macro]
      end unless macro == :selenium
    else
      warn ".di ending prior diversion"
      @current_block = @state[:diversion_stack].pop
    end
  end

  # REVIEW what happens when you .da a not-previously-.di'ed macro?
  def req_da(macro = nil, *args)
    if macro
      warn ".da appending diversion #{macro.inspect}"
      @state[:diversion_stack] << @current_block
      @current_block = blockproto
      @state[:diversions][macro] ||= []
      @state[:diversions][macro] << @current_block
      define_singleton_method "req_#{Troff.quote_method macro}" do |*args|
        warn "inserting diversion #{macro.inspect}"
        @document << @state[:diversions][macro]
      end unless macro == :selenium or respond_to? "req_#{Troff.quote_method macro}"
    else
      warn ".da ending prior diversion"
      @current_block = @state[:diversion_stack].pop
    end
  end

  def init_di
    @state[:diversion_stack] = []
    @state[:diversions] = {
      :selenium => []
    }
  end
end
