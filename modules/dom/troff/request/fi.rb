# fi.rb
# -------------
#   troff
# -------------
#
#   §4.2
#
# Request  Initial  If no     Notes   Explanation
#  form     value   argument
#
# .fi      on       -         B,E     Fill subsequent output lines. The register .u is 1
#                                     in fill mode and 0 in no-fill mode.
#
# TODO: §4.2 A word within filled text may be interrupted by terminating the word with
#            '\c'; the next encountered text will be taken as a continuation of the
#            interrupted word. If the intervening control lines cause a break, any
#            partial line will be forced out along with any partial word.
#

module Troff
  def req_fi
    @register['.u'].value = 1
    # do we need to break? or is this already a brand new block.
    if @current_block.immutable?
      @current_block = blockproto
      @current_block.style.css[:margin_top] = 0
      @document << @current_block
    end
  end
end
