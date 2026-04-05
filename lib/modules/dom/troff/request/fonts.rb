# frozen_string_literal: true
#
# fonts.rb
# -------------
#   troff
# -------------
#
#   §2.2
#
# \fN, \fx
#
#   §2.3
#
# it is not necessary to change to the Special Font; characters on that font are handled
# automatically.
#
# \s >39 are not possible. \s40 is parsed as \s4 and 0 is copied.
#

class Troff
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

  def cs(argstr = '', breaking: nil)
    (face, width, ptsiz) = argstr.split
    return unless face
    ptsiz ||= @register['.s'].value

    if width
      warn "wishfully enabling .cs #{[face, width, ptsiz].inspect}"
      @cs = face
    else
      "disabling .cs #{[face, width, ptsiz].inspect}"
      @cs = nil if @cs
    end
    #@current_block = blockproto
    #@document << @current_block
  end

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

  def fp(argstr = '', breaking: nil)
    (pos, font, file) = argstr.split
    return nil unless pos and font
    return nil.tap { warn "illegal load of font position 0" } if pos == '0'
    warn "loading font #{font} on position #{pos} (file: #{file.inspect})"
    mount_font pos.to_i, font
  end

  # Request       Initial   If no     Notes   Explanation
  #  form          value    argument
  #
  # .ft F         Roman     previous  E       Font changed to F. Alternatively, embed \fF.
  #                                           The font name P is reserved to mean the
  #                                           previous font.

  def ft(argstr = '', breaking: nil)
    f = argstr[0..1].strip
    pos = case f
          when 'P', '' then @previous_fp
          when /^[A-Z][A-Z]?$/
            @font_positions[f] || (warn "automatically mounted font #{f} on position 0" ; mount_font(0, f)) # mount it on position 0
          else f.to_i
          end
    @previous_fp = @register['.f'].value
    @register['.f'].value = pos
    activate_font
    ''
  end

  # Request       Initial   If no     Notes   Explanation
  #  form          value    argument
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

  def ps(argstr = '', breaking: nil)
    ps = argstr[0..2].strip
    size = case ps
           when '0', ''            then @previous_ps
           when /^([-+])(\d{1,2})/ then @register['.s'].value.send(Regexp.last_match(1), Regexp.last_match(2).to_i)
           else                    ps.to_i
           end

    @previous_ps = @register['.s'].value
    #apply { @current_block.terminal_font.size = size }

    # see note in \v about this scaling of baseline shift
    # summary: if we have a pending baseline shift with no output yet, the shift
    #          needs scaling based on the previous font size
    # TODO so far this is just making a bigger mess.
    #cur = @current_block.terminal_text_obj
    #if !cur.immutable? and cur.style[:baseline]
    #  cur.style[:baseline] = cur.style[:baseline] * (@register['.s'].value / size)
    #end

    @register['.s'].value = size
    activate_font
    ''
  end

  alias :esc_s :ps

  # Request       Initial   If no     Notes   Explanation
  #  form          value    argument
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

  def ss(argstr = '', breaking: nil)
    ss = argstr.split.first || Font.defaultsize
    new_style = Style.new(@current_block.terminal_text_style.dup)
    current_spacing = new_style[:word_spacing] || @default_word_spacing
    new_spacing = ss.to_f / 36
    if new_spacing == @default_word_spacing
      apply { @current_block.terminal_text_style.delete(:word_spacing) }
    else
      apply { @current_block.terminal_text_style[:word_spacing] = new_spacing }
    end
  end

  def init_fp
    @fonts = Array.new(16) # need this allocated for direct manipulation of font slots; 16 is arbitrary. Solaris 10 has 11.
    @mounted_fonts = {}
    @font_positions = {}
    @previous_fp = 1
    @previous_ps = Font.defaultsize

    mount_font 0, nil # REVIEW side effects of nil key on @font_positions?
    mount_font 1, 'R'
    mount_font 2, 'I'
    mount_font 3, 'B'
    #mount_font 4, 'S' # REVIEW necessary? correct?
  end

  def init_ss
    @default_word_spacing = 12/36.0
  end

  def mount_font(pos, name)
    @mounted_fonts[pos] = name
    @font_positions[name] = pos
    # convenient in .ft to return pos
    pos
  end

  def activate_font
    font_name = @mounted_fonts[@register['.f'].value]
    font_class = Kernel.const_get("Font::#{font_name}")
  rescue NameError
    warn "trying to use unknown font #{font_name} on position #{@register['.f'].value}"
    font_class = Kernel.const_get(:Font)
  ensure
    apply { @current_block.terminal_font = font_class.new(size: @register['.s'].value) }
  end
end
