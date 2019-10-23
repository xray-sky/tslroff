# SM.rb
# -------------
#   troff
# -------------
#
#   .SM text
#
#     Make text 1 point smaller than default point size.
#
# TODO: this fails on constructs like
#       .TP
#       .SM
#       .B whatever
#
#       [GL2-W2.5] sh.1
#

module Troff
  def req_SM(*args)
    req_ps(Font.defaultsize)
    req_ps('-1')

    if args
      unescape(args.join(' '))
      send(:finalize_SM)
    else
      it_adj
      req_it(1, :finalize_SM)
    end
  end

  def finalize_SM
    req_ps(Font.defaultsize)	# it's possible somebody messed with the font size in the .SM text
    process_input_traps
  end

end
