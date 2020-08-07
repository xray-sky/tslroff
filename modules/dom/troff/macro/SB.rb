# SB.rb
# -------------
#   troff
# -------------
#
#   smaller text, bold
#
# TODO: move this to whatever platform this is defined for; it's not a SysV macro
#

module Troff
  def req_SB(*args)
    req_ps(Font.defaultsize)
    req_ps('-1')
    req_ft('B')

    if args.any?
      unescape(args.join(' '))
      send(:finalize_SB)
    else
      req_it(1, :finalize_SB)
    end
  end

  def finalize_SB
    req_ft
    req_ps
  end

end
