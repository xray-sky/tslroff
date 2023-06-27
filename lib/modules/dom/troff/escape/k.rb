# k.rb
# -------------
#   troff
# -------------
#

module Troff
  def esc_k(s)
    s.slice!(0) if s.start_with?('(')
    warn "using \\k to store a horizontal position in #{s}..."
    block = Block::Selenium.new(style: @current_block.style.dup)
    last_break = @current_block.text.rindex { |t| t[:tab_stop] == 0 }
    block.text = @current_block.text.slice(last_break..-1)

    # keep a single trailing whitespace from being eaten in html -- lex(1) [SunOS 5.5.1]
    last_text = block.text.reverse.detect { |t| !t.empty? }
    # might not be a straight String
    last_text.text.sub!(/\s$/, '&nbsp;') if last_text.text.respond_to? :sub!

    @register[s] = Register.new(0)
    @register[s].value = typesetter_width(block).to_i unless block.to_s.empty?
    warn "\\k stored #{@register[s].value} in #{s}"
    ''
  end
end
