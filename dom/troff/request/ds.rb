# ds.rb
# -------------
#   troff
# -------------
#
#   define a named string
#

module Troff
  def req_ds(args)
    # TODO: a string might re-define itself using its existing contents
    #       see: spline.1g [SunOS 2.0]
    #       I worry about needing to partially unescape the arglist because of \f
    #       or doubly-parsing \(fm or something
    #       but clearly \* and \n need to be interpreted immediately
    #       and there's the fun whatever of a construct like \f\n(98 or \s\n(99
    # TODO: what about '.ds 11 "y\(fm\(fm'
    ns = args.shift.to_sym
    warn "defining #{ns}"
    @state[:named_strings][ns] = Block.new(type: :bare) #args.join(' ') # unescape("#{args.join(' ')}")
    warn @state[:named_strings][ns].inspect
    hold_block = @current_block
    @current_block = @state[:named_strings][ns]
    warn @current_block.inspect
    unescape(args.join(' '))
    #warn @current_block.inspect
    @current_block = hold_block
    warn @current_block.inspect
    warn @state[:named_strings][ns].inspect
    warn
  end
end