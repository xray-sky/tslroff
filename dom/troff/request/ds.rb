# ds.rb
# -------------
#   troff
# -------------
#
#   define a named string
#

module Troff
  def req_ds(args)
    # a string might re-define itself using its existing contents
    # see: spline.1g [SunOS 2.0]
    ns = args.shift.to_sym
    @state[:named_strings][ns] = unescape("\\*{args.join(' ')}")
  end
end