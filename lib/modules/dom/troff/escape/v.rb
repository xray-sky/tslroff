# v.rb
# -------------
#   troff
# -------------
#
#   local vertical motion
#
#   negative values shift carriage toward top of page
#
#  this takes place at the current font size. since we aren't outputting anything
#  in html context to represent the current font size, we need to do something to get
#  the right amount of space when we have set a size for the motion that is different
#  from the last output.
#
#    e.g. gamma(3) puts 8pt bounds on a 10pt integral -- \s10\(is\d\s80\s10\u\u\s8\(if
#    - because we are applying baseline shift as a text style, you can see how the
#      10 point size will have changed to 8 by the time output appears in the Text object
#      and will be rendered in the browser at the smaller size.
#
#      maybe the place to "fix" this is in .ps - ugh.
#
# REVIEW
#   what is the default unit?? v? -- yes.
#

module Troff
  def esc_v(s)
    quotechar = Regexp.quote(get_char(s))
    req_str = s.sub(/^#{quotechar}(.*)#{quotechar}$/, '\1')
    if req_str.match?(/^([-\w.]+)/)
      new_style = Style.new(@current_block.terminal_text_style.dup)
      current_baseline = new_style[:baseline] || 0
      new_baseline = to_em("#{current_baseline}m+#{to_u(req_str, default_unit: 'v')}u").to_f
      if new_baseline == 0
        apply { @current_block.terminal_text_style.delete(:baseline) }
      else
        apply { @current_block.terminal_text_style[:baseline] = new_baseline }
      end
    else
      warn "don't know how to \\v #{req_str.inspect}"
    end
    ''
  end
end
