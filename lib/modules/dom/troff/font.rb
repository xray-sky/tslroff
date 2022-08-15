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

  def req_ft(pos = 'P')
    font = case pos
           when 'P'
             @register[:prev_fp].value
           when /^([A-Z])$/, /^\(?([A-Z]{2})$/ # a two char font name from \f will have a ( up front
             pos = Regexp.last_match[1]
             @state[:fonts].index(pos) || (@state[:fonts][0] = pos and 0) # mount it on position 0
           else              pos.to_i
           end
    @register[:prev_fp].value = @register['.f'].value
    @register['.f'].value = font
    change_font
    ''
  end

  def req_ps(ps = '0')
    size = case ps.to_s # tolerate receiving Integer argument
           when '0'                then @register[:prev_ps].value
           when /^([-+])(\d{1,2})/ then @register['.s'].value.send(Regexp.last_match(1), Regexp.last_match(2).to_i)
           else                    ps.to_i
           end

    @register[:prev_ps].value = @register['.s'].value
    #apply { @current_block.text.last.font.size = size }

    # see note in \v about this scaling of baseline shift
    # summary: if we have a pending baseline shift with no output yet, the shift
    #          needs scaling based on the previous font size
    # TODO so far this is just making a bigger mess.
    #cur = @current_block.text.last
    #if !cur.immutable? and cur.style[:baseline]
    #  cur.style[:baseline] = cur.style[:baseline] * (@register['.s'].value / size)
    #end

    @register['.s'].value = size
    #@current_block << change_font
    change_font
    ''
  end

  def change_font
    begin
      fontclass = Kernel.const_get("Font::#{@state[:fonts][@register['.f'].value]}")
    rescue NameError
      fontclass = Kernel.const_get('Font').tap { |n| warn "trying to use unknown font #{@state[:fonts][@register['.f'].value].inspect}" }
    end
    # what were we thinking of, Font has no style?
    #apply { @current_block.text.last.font = fontclass.new(size: @register['.s'].value,
    #                                                     style: @current_block.text.last.style.dup) }
    apply { @current_block.text.last.font = fontclass.new(size: @register['.s'].value) }
  end

  def init_font
    @register[:prev_fp] = Register.new
    @register[:prev_ps] = Register.new
    true
  end

  alias_method :esc_f, :req_ft
  alias_method :esc_s, :req_ps

end
