# h.rb
# -------------
#   troff
# -------------
#
#   local horizontal motion
#
#   negative values shift carriage toward left margin
#
#   REVIEW is \h'|...' to move to an absolute horizontal position? it's not documented
#          that I found but ar(4) [SunOS 5.5.1] seems to indicate it is.
#
#   TODO trying to \w a lonely \h fails, as there's no text component and
#        selenium considers it unrenderable -- spline(1g) [GL2 W2.5]
#        pathological interactions with .ds and \* ========> so.... now what?
#
# TODO need to clear horizontal shift after tab, break, block, etc. once it's
#      happened, it's stuck on forever. ascii(5) - [GL2-W2.5]
#       - solve this by differentiating leftward and rightward shifts; making
#      rightward motion insert an empty span (like a thin space) and a
#      leftward motion by putting an explicit (narrower) width on the span? - collect examples

module Troff
  def esc_h(s)
    if s.match(/^h(\D)([-\w\.]+)\1/)
      warn "horizontal motion: #{s.inspect}"
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
