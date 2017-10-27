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
    # TODO: what about '.ds 11 "y\(fm\(fm' -- what's that double-quote about?
    ns = args.shift.to_sym
    @state[:named_strings][ns] = Block.new(type: :bare, text: Text.new(font: @current_block.text.last.font.dup))
    # set the current font and freeze it
    # otherwise with a string like "\f2text\fP" 
    # \fP will not be able to restore the previous font
    hold_block = @current_block
    @current_block = @state[:named_strings][ns]
    #@current_block.text.last.font = hold_block.text.last.font.dup
    @current_block.text.last.font.freeze
    # now things are "normal"
    unescape(args.join(' '))
    @current_block = hold_block
    #warn "defined #{ns} ==> #{@state[:named_strings][ns].inspect}"
  end
end