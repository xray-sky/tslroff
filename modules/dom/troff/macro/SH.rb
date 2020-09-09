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
    req_fi
    apply { @current_block.type = :sh }
    unescape(args.join(' '))
    @state[:section] = @current_block.to_s
    req_nr(')R', '0')
    req_P
  end
end
