# fonts.rb
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
# .ft F         Roman     previous  E       Font changed to F. Alternatively, embed \fF.
#                                           The font name P is reserved to mean the
#                                           previous font.
#
# REVIEW does this need to track mounted fonts? does R always mean position 1 even if
#        something else is mounted there?
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
# .ps ±N        10pt      previous  E       Point size set to ±N. Alternatively, embed
#                                           \sN or \s±N. Any positive size value may be
#                                           requested; if invalid, the nearest valid size
#                                           will result, with a maximum size to be
#                                           determined by the individual printing device.
#                                           A paired sequence +N, -N will work because the
#                                           previous value is also remembered.
#                                           Ignored in nroff.
#
#   our default font size is 12pt
#
# .ss N         12/36em   previous  E       Point size set to ±N. Alternatively, embed
#                                           \sN or \s±N. Any positive size value may be
#                                           requested; if invalid, the nearest valid size
#                                           will result, with a maximum size to be
#                                           determined by the individual printing device.
#                                           A paired sequence +N, -N will work because the
#                                           previous value is also remembered.
#                                           Ignored in nroff.
#
#   our default font size is 12pt
#
#  REVIEW what happens when given not-an-N as first arg (invalid expression)
#         ignored, I think, which means bad interaction from to_u returning '0' in that case
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

class Troff
  def cs(argstr = '', breaking: nil)
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

  def fp(argstr = '', breaking: nil)
    (pos, font, file) = argstr.split
    return nil unless pos and font
    return nil.tap { warn "illegal load of font position 0" } if pos == '0'
    warn "loading font #{font} on position #{pos} (file: #{file.inspect})"
    @state[:font][pos.to_i] = font
  end

  def ss(argstr = '', breaking: nil)
    ss = argstr.split.first || Font.defaultsize
    new_style = Style.new(@current_block.terminal_text_style.dup)
    current_spacing = new_style[:word_spacing] || @state[:default_ss]
    new_spacing = ss.to_f / 36
    if new_spacing == @state[:default_ss]
      apply { @current_block.terminal_text_style.delete(:word_spacing) }
    else
      apply { @current_block.terminal_text_style[:word_spacing] = new_spacing }
    end
  end

  def init_fp
    @mounted_fonts = {
      0   => nil,
      1   => 'R',
      2   => 'I',
      3   => 'B',
      #4   => :symbol, # REVIEW necessary? correct?
    }
  end

  def init_ss
    @state[:default_ss] = 12/36.0 # REVIEW is this correctly Font.defaultsize/36.0?
  end

end
