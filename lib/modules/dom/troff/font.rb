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
# TODO \f(xx
#      a request for a named but not mounted font causes it to be mounted on fp 0
#      fp 0 is otherwise inaccessible
#
#      the position of the current font is available in the read-only number
#      register, .f
#
#      \f(BI (bold-italic) in scsiformat(8c) [AOS 4.3]
#
module Troff

  def req_ft(pos = 'P')
    font = case pos
           when 'P'          then @register[:prev_fp].value
           when /[A-Z]{1,2}/ then @state[:fpmap][pos]
           else              pos.to_i
           end
    @register[:prev_fp].value = @register['.f'].value
    apply { @current_block.text.last.font.face = @state[:fonts][font] }
    @register['.f'].value = font
    ''
  end

  def req_ps(ps = '0')
    size = case ps.to_s # tolerate receiving Integer argument
           when '0'                then @register[:prev_ps].value
           when /^([-+])(\d{1,2})/ then @register['.s'].value.send(Regexp.last_match(1), Regexp.last_match(2).to_i)
           else                    ps.to_i
           end

    @register[:prev_ps].value = @register['.s'].value
    apply { @current_block.text.last.font.size = size }
    @register['.s'].value = size
    ''
  end

  def init_font
    @register[:prev_fp] = Register.new
    @register[:prev_ps] = Register.new
    true
  end

  alias esc_f req_ft
  alias esc_s req_ps

end
