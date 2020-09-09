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
    req_fi
    apply { @current_block.type = :ss }
    unescape(args.join(' '))
    req_nr(')R', '0')
    req_P
  end
end
