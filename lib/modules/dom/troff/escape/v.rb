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
    #warn "not yet tokenized - #{__callee__}"
    #warn "arrived in \\v with #{s.inspect}"
    quotechar = Regexp.quote(get_char(s))
    req_str = s.sub(/^#{quotechar}(.*)#{quotechar}$/, '\1')
    if req_str.match?(/^([-\w\.]+)/)
      new_style = Style.new(@current_block.text.last.style.dup)
      current_baseline = new_style[:baseline] || 0
      new_baseline = to_em("#{current_baseline}m+#{req_str}").to_f
      if new_baseline == 0
        apply { @current_block.text.last.style.delete(:baseline) }
      else
        apply { @current_block.text.last.style[:baseline] = new_baseline }
      end
      #s.sub(/#{Regexp.quote(full_esc)}/, '')
      ''
    else
      #warn "don't know how to #{s.inspect}"
      #s
      warn "don't know how to \\v #{req_str.inspect}"
      ''
    end
  end
end
