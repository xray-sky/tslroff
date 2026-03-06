# drawing.rb
# -------------
#   troff
# -------------
#
#   \b - bracket
#   \l - repeated characters
#   \D - figure drawing
#   \L - vertical line drawing
#

class Troff

#   \b - bracket
#
# TODO
#   these are just splatted on the page apparently without regard to text flow
#   i.e. text just prints around them -- what can be done about this? mh-chart(n) [NEWS-os 4.2.1R]
#   adding css height:0 seems to help but then maybe there's some more vertical alignment to do
#

  def esc_b(s)
    quotechar = Regexp.quote(get_char(s))
    req_str = s.sub(/^#{quotechar}(.*)#{quotechar}$/, '\1')
    warn "\\b trying to draw brackets #{req_str.inspect}"

    justify = req_str.match?(/\(l/) ? 'right' : 'left'
    bracket = Bracket.new(style: @current_block.terminal_text_style.dup, font: Font::R.new(size: @register['.s'].value))
    bracket.style.css[:text_align] = justify
    bracket.style.css.delete :color
    until req_str.empty?
      chr = req_str.slice!(0, get_char(req_str).length)
      warn "\\b unescaping #{chr.inspect}"
      bracket << Text.new(font: bracket.terminal_font.dup, style: bracket.terminal_text_style.dup)
      unescape chr, output: bracket
    end

    @current_block << bracket
    ''
  end

#   \l - repeated characters
#
#   §12.4
#
#   \l'Nc' draws a string of repeated characters 'c' toward the right for a distance of N
#   if c looks like a continuation of an expression for N, it may be insulated from N with
#   a \&. If c is not specified, the _ (baseline rule) is used. If N is negative, a
#   backward horizontal motion of size N is made before drawing the string. Any space
#   resulting from N/(size of c) having a remainder is put at the beginning (left end) of
#   the string. In the case of characters that are designed to be connected such as
#   baseline-rule, underrule, and root-en, the remainder space is covered by overlapping.
#   If N is less than the width of c, a single c is centered on a distance N. As an example,
#   a macro to underscore a string can be written
#
#     .de us
#     \\$1\ l ' | 0\(ul'
#     ..
#
#    MORE
#
#    TODO
#
#    WTF
#
# ??
# https://www.quackit.com/character_sets/unicode/versions/unicode_9.0.0/box_drawing_unicode_character_codes.cfm
#

  def esc_l(s)
    # default unit 'm'
    quotechar = Regexp.quote(get_char(s))
    req_str = s.sub(/^#{quotechar}(.*)#{quotechar}$/, '\1')
    #warn "\\l trying to draw horizontal lines from #{req_str.inspect}"
    # special case for '|0\(ul' for underlining
    # consider '|1u\(ul' equivalent. also if \(ul not specified (is default)
    if req_str.match?(/^\|(?:0|1u)(?:\\\(ul)?$/)
      warn "\\l special case for underline macro (check if beginning of line is intended!)"
      last_break = @current_block.text.rindex { |t| t.is_a? LineBreak } || 0
      @current_block.text[last_break..-1].each do |t|
        t.style.css[:text_decoration] = 'underline'
      end
    else
      width = req_str.slice!(0, get_expression(req_str).length)
      #warn "\\l parsed N as #{width.inspect} ; char is #{req_str.inspect}"
      warn "\\l neg/abs position #{width.inspect} - bailing out" and return '' if width.start_with? '|' or width.start_with? '-'
      width = to_em(to_u(width, default_unit: 'm'))
      if ['', '\\(ul'].include? req_str
        warn "\\l special case for hr based on #{width.inspect}em of #{req_str.inspect}"
        @current_block << Rule.new(width: width, font: @current_block.terminal_font.dup, style: @current_block.terminal_text_style.dup)
      else
        warn "\\l ... dunno: #{width.inspect}em of #{req_str.inspect}"
      end
    end
    #unescape(req_str)
    ''
  end

#   \L - vertical line drawing
#

  def esc_L(s)
    # default unit 'v'
    quotechar = Regexp.quote(get_char(s))
    req_str = s.sub(/^#{quotechar}(.*)#{quotechar}$/, '\1')
    warn "\\L trying to draw vertical lines from #{req_str.inspect}"
    #unescape(req_str)
    ''
  end

#   \D - figure drawing
#

  def esc_D(s)
    quotechar = Regexp.quote(get_char(s))
    req_str = s.sub(/^#{quotechar}(.*)#{quotechar}$/, '\1')
    warn "\\D trying to draw figure from #{req_str.inspect}"
    #unescape(req_str)
    ''
  end

end
