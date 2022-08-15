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
#
# when we run out of tabs, nroff outputs nothing... but only if we're already past the
# last tab stop. based on lex(1) [SunOS 5.5.1] we're still meant to position if possible
#

module Troff

  private

  def insert_tab(width: 0, stop: 0)
    hold_style = Text.new(font: @current_block.text.last.font.dup, style: @current_block.text.last.style.dup)
    tabtext = @current_block.text.slice!(@current_block.last_tab_stop..-1)
    @current_block << Tab.new(text: tabtext, width: width, stop: stop,
                             # something weird is happening here with styling tabs immediately after a Break
                             # TODO straighten it out? use units(1) [SunOS 2.0] if it helps
                             style: tabtext.last&.style&.dup || hold_style.style.dup,
                             font: tabtext.last&.font&.dup || hold_style.font.dup)
    @current_block << hold_style
  end

  def next_tab(count = 1)
    position = 0

    block = Block::Selenium.new(style: @current_block.style.dup,
                                 text: @current_block.text.slice(@current_block.last_tab_stop..-1))
    unless block.to_s.empty?
      @@webdriver.get block.to_html
      position = @current_block.last_tab_position +
                 to_u(@@webdriver.find_element(id: 'selenium').size.width.to_s, default_unit: 'px').to_i
    end

    remaining_tabs = @state[:tabs].select { |stop| stop >= position }
    return nil if remaining_tabs.empty?
    if remaining_tabs.count < count
      warn "too few tab stops advancing #{count} from #{remaining_tabs.inspect}"
      return remaining_tabs.last
    end
    remaining_tabs[count-1]
  end

end
