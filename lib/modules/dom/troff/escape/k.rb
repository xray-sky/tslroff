# k.rb
# -------------
#   troff
# -------------
#

module Troff
  def esc_k(s)
    s.slice!(0) if s.start_with?('(')
    #register = s[1]
    #warn "not yet tokenized - #{__callee__}"
    warn "using \\k to store a horizontal position in #{s}..."
    position = 0
    block = Block.new(type: :se, style: @current_block.style.dup)
    last_break = @current_block.text.rindex { |t| t[:tab_stop] == 0 }
    block.text = @current_block.text.slice(last_break..-1)
    #warn block.inspect
    @register[s] = Register.new(0)
    unless block.to_s.empty?
      @@webdriver.get(%(data:text/html;charset=utf-8,#{block.to_html}))
      @register[register].value = to_u(@@webdriver.find_element(id: 'selenium').size.width.to_s, default_unit: 'px').to_i
    end
    warn "\\k stored #{@register[s].value} in #{s}"
  end
end
