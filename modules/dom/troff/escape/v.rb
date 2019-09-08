# v.rb
# -------------
#   troff
# -------------
#
#   local vertical motion
#
#   negative values shift carriage toward top of page
#

module Troff
  def esc_v(s)
    if s.match(/^v(\D)([-\w\.]+)\1/)
      (full_esc, quote_char, motion) = Regexp.last_match.to_a
      new_style = Style.new(@current_block.text.last.style.dup)
      current_baseline = new_style[:baseline] || 0
      new_baseline = to_em("#{current_baseline}m+#{motion}").to_f
      if new_baseline == 0
        apply { @current_block.text.last.style.delete(:baseline) }
      else
        apply { @current_block.text.last.style[:baseline] = new_baseline }
      end
      s.sub(/#{Regexp.quote(full_esc)}/, '')
    else
      warn "don't know how to #{s.inspect}"
      s
    end
  end
end
