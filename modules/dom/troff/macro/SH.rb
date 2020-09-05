# SH.rb
# -------------
#   troff
# -------------
#
#   .SH text
#
#     Place subhead text, for example, SYNOPSIS, here.
#
#  turns fill mode on, if it's off (at least on GL2-W2.5 - REVIEW)

module Troff
  def req_SH(*args)
    text = args.join(' ')
    req_fi
    apply { @current_block.type = :sh }
    unescape(text)
    @state[:section] = @current_block.to_s
    @current_block = blockproto
    @document << @current_block
  end
end
