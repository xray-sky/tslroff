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
# mounts, but does not select
#

module Troff
  def req_fp(pos, font, file = nil)
    warn "don't know how to load #{font} on position #{pos}"
    #@state[:font][pos] = # TODO: something.
  end

  def init_fp
    @state[:fpmap] = { 'R' => 1, 'I' => 2, 'B' => 3 }
    @state[:fonts] = {
      0 => nil,
      1 => Font.new(face: :regular),
      2 => Font.new(face: :italic),
      3 => Font.new(face: :bold)#,
      #4 => Font.new(family: :math) # TODO: output
    }
    true
  end
end
