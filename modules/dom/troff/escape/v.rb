# v.rb
# -------------
#   troff
# -------------
#
#   local vertical motion
#   positive values shift carriage toward top of page
#
# TODO: lots (scale units, etc.)
#

module Troff
  def esc_v(s)
    if s.match(/^v(\D)([-\w\.]+)\1/)
      (full_esc, quote_char, motion) = Regexp.last_match.to_a
      warn "moving carriage #{motion.inspect} due to #{s.inspect}"
      cur_base = @current_block.text.last.style[:baseline]
      warn "current base: #{cur_base.inspect}"
      s.sub(/#{Regexp.quote(full_esc)}/, '')
    else
      warn "don't know how to #{s.inspect}"
      s
    end
  end
end
