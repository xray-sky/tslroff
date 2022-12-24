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
  define_method 'SH' do |*args|
    req_fi
    req_nr(')R 0')
    xinit_in
    #apply { @current_block.type = :sh }
    @current_block = blockproto Block::Head
    @document << @current_block
    unescape(args.join(' '))
    @state[:section] = @current_block.to_s
    send 'P'
  end
end
