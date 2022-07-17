# tabs.rb
# ---------------
#    Troff tab processing routines
# ---------------
#
# TODO: how do tabs interact with .TP / .IP / .RS etc. ?
#
# REVIEW: details in §9.1, §9.2
# REVIEW: returns nil if we're out of tabs
#
# vertical motion must be suppressed when calculating widths through selenium
# due to display:block;width:100%; - becomes measuring width:100% - this is
# done by closing the text block and resetting text[:tab_stop] any time there's
# a break or vertical space. So when it gets here, there's nothing extra needed.

module Troff

  private

  def next_tab(count = 1)
    position = 0
    block = Block.new(type: :se, style: @current_block.style.dup) # TODO no .style on String, if we get a \t in a comment
    last_stop = @current_block.text.rindex { |t| t[:tab_stop] }
    block.text = @current_block.text.slice(last_stop..-1)
    unless block.to_s.empty?
      @@webdriver.get(%(data:text/html;charset=utf-8,#{block.to_html}))
      position = block.text[0][:tab_stop] + to_u(@@webdriver.find_element(id: 'selenium').size.width.to_s, default_unit: 'px').to_i
    end
    @state[:tabs].select { |stop| stop >= position }[count-1]
  end

end
