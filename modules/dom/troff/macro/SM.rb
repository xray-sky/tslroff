# SM.rb
# -------------
#   troff
# -------------
#
#   .SM text
#
#     Make text 1 point smaller than default point size.
#

module Troff
  def req_SM(*args)
    req_ps(Font.defaultsize)
    req_ps('-1')
    if args.any?
      unescape(args.join(' '))
      send(:finalize_SM)
    else
      req_it(1, :finalize_SM)
    end
  end

  def finalize_SM
    req_ps(Font.defaultsize)	# it's possible somebody messed with the font size in the .SM text
  end

end
