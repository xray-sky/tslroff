# fp.rb
# -------------
#   troff
# -------------
#
#   §2.3
#
# Request       Initial   If no     Notes   Explanation
#  form          value    argument
#
# .fp N F file  -         ignored   -       Font position. This is a statement that a
#                                           font named F is mounted on position N. It is
#                                           a fatal error if F is not known. Fonts and the
#                                           possible range of their numerical positions is
#                                           device dependent. .fp accepts a third optional
#                                           argument, file, which is an alternate version
#                                           of the font F.
#
#  mounts, but does not select
#
#  REVIEW what happens when given not-an-N as first arg (invalid expression)
#         ignored, I think, which means bad interaction from to_u returning '0' in that case
#
# REVIEW TODO
# solaris 10 troff mounts these fonts:
#   x font 1 R
#   x font 2 I
#   x font 3 B
#   x font 4 BI
#   x font 5 CW
#   x font 6 H
#   x font 7 HB
#   x font 8 HX
#   x font 9 S1
#   x font 10 S
#   s10
#

module Troff
  def req_fp(argstr = '', breaking: nil)
    (pos, font, file) = argstr.split
    return nil unless pos and font
    return nil.tap { warn "illegal load of font position 0" } if pos == '0'
    warn "loading font #{font} on position #{pos} (file: #{file.inspect})"
    @state[:font][pos.to_i] = font
  end

  def init_fp
    @state[:fonts] = {
      0   => nil,
      1   => 'R',
      2   => 'I',
      3   => 'B',
      #4   => :symbol, # REVIEW necessary? correct?
    }
  end
end
