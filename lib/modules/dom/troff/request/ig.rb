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

module Troff
  def req_ig(term_str = '.', *_args)
    save_block = @current_block
    @current_block = blockproto
    begin
      @lines.collect_through do |l|
        @register['.c'].incr
        unescape(l, copymode: true)
        l.start_with?('.' + term_str)
      end
    rescue StopIteration
      warn "end of input during .ig looking for #{term_str.inspect})!"
    end
    @current_block = save_block
  end
end
