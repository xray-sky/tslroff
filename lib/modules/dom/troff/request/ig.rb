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
#  REVIEW ^^ still?
#

module Troff
  def req_ig(argstr = '', breaking: nil)
    delim = argstr.split.first || '.'
    # like .de, it's not actually a method invocation
    # and in fact '.ig foooobar' will .ig until '.foooobar' occurs
    #terminating_method = "req_#{Troff.quote_method delim}"
    #define_singleton_method(terminating_method) { |*_args| true }

    #save_block = @current_block
    # break_adj in blockproto is incorrectly eating terminal breaks in nofill mode
    #@current_block = Block::Paragraph.new#(type: :p) # REVIEW use Block::Bare instead? or Block::Null?

    #until @line.start_with? ".#{delim}" do
      # actually we don't want to process this at all! the lines are ignored
      # no font changes, no register changes, etc. no macros processed.
      # but "auto-incremented registers will be effected".
      # just ones processed by reading in copy mode; no macros processed
    #  next_line
    #end

    #parse(@line) # ditch the terminating request - TODO this should cause a break, incl. line if in .nf -- if(1) [SunOS 5.5.1]
    #singleton_class.send(:remove_method, terminating_method)

    #@current_block = save_block

    loop do
      next_line
      break if @line == ".#{delim}"
      unescape @line, copymode: true # copymode won't output anything, but will auto-increment registers
    end
    ''
  end
end
