# SM.rb
# -------------
#   troff
# -------------
#
#   smaller text
#

module Troff
  def req_SM(*args)
    req_ps(Font.defaultsize)
    req_ps('-1')

    if args
      unescape(args.join(' '))
      send(:finalize_SM)
    else
      req_it(1, :finalize_SM)
    end
  end

  def finalize_SM
    req_ps
    process_input_traps
  end

end
