# cc.rb
# -------------
#   troff
# -------------
#
#   §10.4
#
# Request  Initial  If no     Notes   Explanation
#  form     value   argument
#
# .cc c     .       .         E       The basic control character is set to c, or reset to "."
# .c2 c     '       '         E       The no-break control character is set to c, or reset to "'"
#
#    Changes must be compatible with the design of macros used in the span of the change,
#    especially trap-invoked macros.
#

module Troff
  def req_cc(argstr = '', breaking: nil)
    chr = argstr.empty? ? '.' : argstr[0]
    @state[:cc] = chr
    true
  end

  def req_c2(argstr = '', breaking: nil)
    chr = argstr.empty? ? "'" : argstr[0]
    @state[:c2] = chr
    true
  end

  def init_cc
    req_cc
    req_c2
  end
end
