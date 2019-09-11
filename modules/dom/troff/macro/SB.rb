# SB.rb
# -------------
#   troff
# -------------
#
#   smaller text, bold
#

module Troff
  def req_SB(*args)
    req_ps(Font.defaultsize)
    req_ps('-1')
    req_ft('B')

    if args
      unescape(args.join(' '))
      send(:finalize_SB)
    else
      req_it(1, :finalize_SB)
    end
  end

  def finalize_SB
    req_ft
    req_ps
    process_input_traps
  end

end
