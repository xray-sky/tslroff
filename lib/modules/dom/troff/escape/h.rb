# h.rb
# -------------
#   troff
# -------------
#
#   local horizontal motion
#
#   negative values shift carriage toward left margin
#
#   The absolute position indicator | may be prepended to a number N to generate the
#   distance to the vertical or horizontal place N. (§1.3, p.21)
#
#   => apparently this applies to all horizontal and vertical requests. (UGH)
#      .ll, .in, .ti, .ta, .lt, .p, .mc, \h, \l
#      .pl, .wh, .ch, .dt, .sp, .sv, .ne, .rt, \v, \x, \L
#
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
#
# TODO default unit 'm'

module Troff
  def esc_h(s)
    quotechar = Regexp.quote(get_char(s))
    req_str = __unesc_w(__unesc_n(s.sub(/^#{quotechar}(.*)#{quotechar}$/, '\1'))) # we may have come here without having getargsed
    if req_str.match?(/^[-\w.]+/)
      warn "horizontal motion: #{req_str.inspect}"
      new_style = Style.new(@current_block.terminal_text_style.dup)
      current_shift = new_style[:horizontal_shift] || 0
      new_shift = to_em("#{current_shift}m+#{req_str}").to_f
      if new_shift == 0
        apply { @current_block.terminal_text_style.delete(:horizontal_shift) }
      else
        apply { @current_block.terminal_text_style[:horizontal_shift] = new_shift }
      end
    elsif req_str.start_with?('|')
      req_str.slice!(0)
      warn "attempting to \\h to absolute pos #{req_str.inspect}" # TODO/REVIEW maybe this can, for practical purposes, be handled like a tab? - ar(4) [SunOS 5.5.1]
      warn "^^^ not from beginning of line!" unless broke? # TODO this warning is tripping apparently incorrectly on lex(1) [SunOS 5.5.1] since we're in nofill and just had a linebreak. why?
      new_shift = to_em(req_str.to_s).to_f
      if new_shift.zero?
        apply { @current_block.terminal_text_style.delete(:horizontal_shift) }
      elsif nofill?
        warn ">>> treating it like a tab of #{new_shift}em due to nofill"
        insert_tab width: new_shift
      else
        apply { @current_block.terminal_text_style[:horizontal_shift] = new_shift }
      end
    else
      warn "don't know how to \\h #{req_str.inspect}"
    end
    ''
  end
end
