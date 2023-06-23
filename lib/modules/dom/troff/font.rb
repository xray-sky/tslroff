# Fonts (troff)
#   definition of the \f (change font) escape
#
#   §2.2
#
# \fN, \fx
#
# it is not necessary to change to the Special Font; characters on that font are handled
# automatically.
#
# \s >39 are not possible. \s40 is parsed as \s4 and 0 is copied.
#
#

module Troff

  def req_ft(argstr = '', breaking: nil)
    argstr.slice!(0) if argstr.start_with? '(' # a two char font name from \f will have a ( up front
    pos = argstr.slice(0, 2).strip
    font = case pos
           when 'P', '' then @register[:prev_fp].value
           when /^[A-Z]+$/
             @state[:fonts].index(pos) || (warn "automatically mounted font #{pos} on position 0" ; @state[:fonts][0] = pos and 0) # mount it on position 0
           else pos.to_i
           end
    @register[:prev_fp].value = @register['.f'].value
    @register['.f'].value = font
    change_font
    ''
  end

  def req_ps(argstr = '', breaking: nil)
    ps = argstr.slice(0, 3).strip
    size = case ps.to_s # tolerate receiving Integer argument
           when '0', ''            then @register[:prev_ps].value
           when /^([-+])(\d{1,2})/ then @register['.s'].value.send(Regexp.last_match(1), Regexp.last_match(2).to_i)
           else                    ps.to_i
           end

    @register[:prev_ps].value = @register['.s'].value
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
    change_font
    ''
  end

  def change_font
    begin
      fontclass = Kernel.const_get("Font::#{@state[:fonts][@register['.f'].value]}")
    rescue NameError
      fontclass = Kernel.const_get('Font').tap { |n| warn "trying to use unknown font #{@state[:fonts][@register['.f'].value].inspect} (position #{@register['.f'].value.inspect})" }
    end
    apply { @current_block.terminal_font = fontclass.new(size: @register['.s'].value) }
  end

  def init_font
    @register[:prev_fp] = Register.new
    @register[:prev_ps] = Register.new
    true
  end

  alias_method :esc_f, :req_ft
  alias_method :esc_s, :req_ps

end
