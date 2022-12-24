# cs.rb
# -------------
#   troff
# -------------
#
#   §2.3
#
# Request       Initial   If no     Notes   Explanation
#  form          value    argument
#
# .cs F N M     off       -         P       Constant character space (width) mode is set
#                                           on for font F (if mounted); the width of every
#                                           character will be taken to be N/36 ems. If M
#                                           is absent, the em is that of the character's
#                                           point size; if M is given, the em is M points.
#                                           All affected characters are centered in this
#                                           space, including those with an actual width
#                                           larger than this space. Special Font characters
#                                           occurring while the current font is F are also
#                                           so treated. If N is absent, the mode is turned
#                                           off. The mode must be still on or again in
#                                           effect when the characters are physically
#                                           printed. Ignored in nroff.
#
#   ugh.
#
#   REVIEW not worth a thorough implementation if we never see it outside
#          of ascii(7) [AOS 4.3] -- this is enough for that use.
#

module Troff
  def req_cs(argstr = '', breaking: nil)
    (face, width, ptsiz) = argstr.split
    return nil unless face
    ptsiz ||= @register['.s'].value

    if width
      warn "wishfully enabling .cs #{[face, width, ptsiz].inspect}"
      @state[:cs] = face
    else
      "disabling .cs #{[face, width, ptsiz].inspect}"
      @state.delete(:cs) if @state[:cs]
    end
    @current_block = blockproto
    @document << @current_block
  end
end
