# ss.rb
# -------------
#   troff
# -------------
#
#   §2.3
#
# Request       Initial   If no     Notes   Explanation
#  form          value    argument
#
# .ss N         12/36em   previous  E       Point size set to ±N. Alternatively, embed
#                                           \sN or \s±N. Any positive size value may be
#                                           requested; if invalid, the nearest valid size
#                                           will result, with a maximum size to be
#                                           determined by the individual printing device.
#                                           A paired sequence +N, -N will work because the
#                                           previous value is also remembered.
#                                           Ignored in nroff.
#
#   our default font size is 12pt
#

module Troff
  def req_ss(ss = '12')
    new_style = Style.new(@current_block.text.last.style.dup)
    current_spacing = new_style[:word_spacing] || @state[:default_ss]
    new_spacing = ss.to_f / 36
    if new_spacing == @state[:default_ss]
      apply { @current_block.text.last.style.delete(:word_spacing) }
    else
      apply { @current_block.text.last.style[:word_spacing] = new_spacing }
    end
  end

  def init_ss
    @state[:default_ss] = 12/36.0
  end
end
