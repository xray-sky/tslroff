# h.rb
# -------------
#   troff
# -------------
#
#   local horizontal motion
#
#   negative values shift carriage toward left margin
#   TODO trying to \w a lonely \h fails, as there's no text component and
#        selenium considers it unrenderable -- spline(1g) [GL2 W2.5]
#        pathological interactions with .ds and \* ========> so.... now what?
#

module Troff
  def esc_h(s)
    if s.match(/^h(\D)([-\w\.]+)\1/)
      (full_esc, quote_char, motion) = Regexp.last_match.to_a
      new_style = Style.new(@current_block.text.last.style.dup)
      current_shift = new_style[:horizontal_shift] || 0
      new_shift = to_em("#{current_shift}m+#{motion}").to_f
      if new_shift == 0
        apply { @current_block.text.last.style.delete(:horizontal_shift) }
      else
        apply { @current_block.text.last.style[:horizontal_shift] = new_shift }
      end
      s.sub(/#{Regexp.quote(full_esc)}/, '')
    else
      warn "don't know how to #{s.inspect}"
      s
    end
  end
end
