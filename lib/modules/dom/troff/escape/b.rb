# b.rb
# -------------
#   troff
# -------------
#
#   definition of the \b (overstrike) escape
#
# TODO
#   these are just splatted on the page apparently without regard to text flow
#   i.e. text just prints around them -- what can be done about this? mh-chart(n) [NEWS-os 4.2.1R]
#   adding css height:0 seems to help but then maybe there's some more vertical alignment to do
#

module Troff
  def esc_b(s)
    quotechar = Regexp.quote(get_char(s))
    req_str = s.sub(/^#{quotechar}(.*)#{quotechar}$/, '\1')
    warn "\\b trying to draw brackets #{req_str.inspect}"

    justify = req_str.match?(/\(l/) ? 'right' : 'left'
    bracket = Bracket.new(style: @current_block.text.last.style.dup,
                           font: Font::R.new(size: @register['.s'].value))
    bracket.style.css[:text_align] = justify
    bracket.style.css.delete :color
    until req_str.empty? do
      chr = req_str.slice!(0, get_char(req_str).length)
    warn "\\b unescaping #{chr.inspect}"
      bracket << Text.new(font: bracket.text.last.font.dup, style: bracket.text.last.style.dup)
      unescape chr, output: bracket
    end

    @current_block << bracket
    ''
  end
end
