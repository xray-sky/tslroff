# SS.rb
# -------------
#   troff
# -------------
#
#   .SS text
#
#     Place sub-subhead text, for example, Options, here.
#
# REVIEW .ti \n()Ru+\n(INu - sunos tmac.an

module Troff
  define_method 'SS' do |*args|
    req_fi
    req_nr(')R 0')
    xinit_in
    #apply { @current_block.type = :ss }
    @current_block = blockproto Block::SubHead
    @document << @current_block
    unescape(args.join(' '))
    send 'P'
  end
end
