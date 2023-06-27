# o.rb
# -------------
#   troff
# -------------
#
#   definition of the \o (overstrike) escape
#
# Automatically centered overstriking of up to 9 characters is provided by the
# overstrike function \o'string'. The characters in string are overprinted with
# centers aligned; the total width is that of the widest character. string should
# not contain local vertical motion. As examples, \o'e\'' produces é
# \o'\(mo\(sl' produces ∉
#
# TODO
#   character centers aligned
# √ there can be font changes involved: \o'\f2n\f1\(rn' -- factor(1) [SunOS 5.5.1] (bold n, with an overbar (extended radical for '\(sr'))
#      ha! but it fails in psroff too - no overstrike.
#
#

module Troff
  def esc_o(s)
    quotechar = Regexp.quote(get_char(s))
    req_str = s.sub(/^#{quotechar}(.*)#{quotechar}$/, '\1')
    warn "\\o trying to overstrike #{req_str.inspect}"
    pile = Block::Bare.new(text: Text.new(font: @current_block.terminal_font.dup, style: @current_block.terminal_text_style.dup))
    until req_str.empty?
      chr = req_str.slice!(0, get_char(req_str).length)
      unescape chr, output: pile
      pile << Text.new(font: @current_block.terminal_font.dup, style: @current_block.terminal_text_style.dup) unless @current_block.terminal_text_obj.empty?
    end
    pile.text.pop # nuke the last empty Text obj
    Overstrike.new(chars: pile.text)#.tap { |n| warn "inserted overstrike #{n.inspect}" }
  end
end
