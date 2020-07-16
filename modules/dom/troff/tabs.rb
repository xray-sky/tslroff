# tabs.rb
# ---------------
#    Troff tab processing routines
# ---------------
#
# TODO: how do tabs interact with .TP / .IP / .RS etc. ?
#
# REVIEW: returns nil if we're out of tabs

module Troff

  private

  def next_tab(count = 1)
    position = 0
    block = Block.new(type: :se, style: @current_block.style.dup)
    last_stop = @current_block.text.rindex { |t| t[:tab_stop] }
    block.text = @current_block.text.slice(last_stop..-1)
    unless block.to_s.empty?
      @webdriver.get("data:text/html;charset=utf-8,#{block.to_html}")
      position = block.text[0][:tab_stop] + to_u(@webdriver.find_element(id: 'selenium').size.width.to_s, default_unit: 'px').to_i
    end
    @state[:tabs][@state[:tabs].find_index { |stop| stop >= position } + (count - 1)]
  end

end
