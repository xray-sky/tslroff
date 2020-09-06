# SS.rb
# -------------
#   troff
# -------------
#
#   .SS text
#
#     Place sub-subhead text, for example, Options, here.
#

module Troff
  def req_SS(*args)
    apply do
      @current_block.type = :ss
      @current_block << args.join(' ')
    end
    req_nr(')R', '0')
    req_P
  end
end
