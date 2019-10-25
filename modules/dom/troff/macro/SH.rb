# SH.rb
# -------------
#   troff
# -------------
#
#   .SH text
#
#     Place subhead text, for example, SYNOPSIS, here.
#

module Troff
  def req_SH(*args)
    text = args.join(' ')
    apply do
      @current_block.type = :sh
      #@current_block << text
    end
    unescape(text)
    @state[:section] = @current_block.to_s
    @current_block = blockproto
    @document << @current_block
  end
end
