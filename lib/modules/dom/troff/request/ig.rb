# ig.rb
# -------------
#   troff
# -------------
#
#   ignore input lines
#
#   §20
#
#
# Request       Initial   If no     Notes   Explanation
#  form          value    argument
#
# .ig yy           -       yy=..     -      .ig behaves exactly like .de except that the
#                                           input is discarded. The input is read in copy
#                                           mode, and any auto-incremented registers will
#                                           be affected.
#
# Note:
#  We will get a warning about an unrecognized request terminating an .ig that
#  did _not_ happen, due to .if -- this does not indicate a problem.
#

module Troff
  def req_ig(delim = '.', *_args)
    terminating_method = "req_#{Troff.quote_method delim}"
    define_singleton_method(terminating_method) { |*_args| true } #{ |*_args| unescape(' ') } # REVIEW unintended side effects?

    save_block = @current_block
    #warn "--- #{save_block.text.last.inspect}"
    #@current_block = blockproto
    # break_adj in blockproto is incorrectly eating terminal breaks in nofill mode
    @current_block = Block.new(type: :p)

    until @line.start_with? ".#{delim}" do
      #@current_block << unescape(next_line, copymode: true)
      # actually we don't want to process this at all! the lines are ignored
      # no font changes, no register changes, etc.
      next_line
    end

    parse(@line) # ditch the terminating request - TODO this should cause a break, incl. line if in .nf -- if(1) [SunOS 5.5.1]
    singleton_class.send(:remove_method, terminating_method)

    @current_block = save_block
    #warn "--- #{@current_block.text.last.inspect}"
  end
end
