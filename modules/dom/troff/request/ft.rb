# ft.rb
# -------------
#   troff
# -------------
#
#   §2.3
#
# Request       Initial   If no     Notes   Explanation
#  form          value    argument
#
# .fp F         Roman     previous  E       Font changed to F. Alternatively, embed \fF.
#                                           The font name P is reserved to mean the
#                                           previous font.
#
# REVIEW does this need to track mounted fonts? does R always mean position 1 even if
#        something else is mounted there?
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
  end

  def init_fp
    @state[:fpmap] = { 'R' => 1, 'I' => 2, 'B' => 3 }
    @state[:fonts] = {
      0 => nil,
      1 => :regular,
      2 => :italic,
      3 => :bold#,
      #4 => :symbol # TODO: output
    }
    @register[:prev_fp] = Register.new
    true
  end
end
