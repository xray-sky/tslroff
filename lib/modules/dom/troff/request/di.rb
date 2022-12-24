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
#                                           Normal text processing occurs during
#                                           diversion except that page offsetting is not
#                                           done. The diversion ends when the request .di
#                                           or .da is encountered without an argument;
#                                           extraneous requests of this type should not
#                                           appear when nested diversions are being used.
#
# .da xx         -        end       D       Divert, appending to xx (append version of .di)
#
# appending a not-previously defined diversion is allowed
#
#   REVIEW is .di the reason we're ending up with short left margins in e.g. the man(5)s ?
#

module Troff
  def req_di(argstr = '', breaking: nil)
    macro = argstr.slice(0, 2).strip
    unless macro.empty?
      warn ".di creating diversion #{macro.inspect}"
      @state[:diversion_stack] << @current_block
      @current_block = blockproto
      @state[:diversions][macro] = [ @current_block ]
      define_singleton_method macro do |*args|
        warn "inserting diversion #{macro.inspect}"
        @document += @state[:diversions][macro]
      end unless macro == :selenium
    else
      warn ".di ending prior diversion"
      @current_block = @state[:diversion_stack].pop
    end
  end

  def req_da(argstr = '', breaking: nil)
    macro = argstr.slice(0, 2).strip
    unless macro.empty?
      warn ".da appending diversion #{macro.inspect}"
      @state[:diversion_stack] << @current_block
      @current_block = blockproto
      @state[:diversions][macro] ||= [] # .da of a not-previously .di'ed macro is the same as .di'ing it
      @state[:diversions][macro] << @current_block
      define_singleton_method macro do |*args|
        warn "inserting diversion #{macro.inspect}"
        @document += @state[:diversions][macro]
      end unless macro == :selenium or respond_to? macro
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
