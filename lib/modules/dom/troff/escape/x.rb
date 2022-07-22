# x.rb
# -------------
#   troff
# -------------
#
#   definition of the \x (extra line space function) escape
#
#  If a word contains a vertically tall construct requiring the output line containing
# it to have extra vertical space before and/or after it, the extra-line-space function
# \x'N' can be embedded in or attached to that word. In this and other functions having
# a pair of delimiters around their parameter (here '), the delimiter choice is arbitrary
# except that it can't look like the continuation of a number expression for N. If N
# is negative, the output line containing the word will be preceeded by N extra vertical
# space. If N is negative, the output line containing the word will be followed by N
# extra vertical space. If successive requests for extra space apply to the same line,
# the maximum values are used. The most recently utilized post-line extra line space
# is available in the .a register.
#
# TODO: how to use the .a register??
#
# REVIEW '0' arg - see spline(1g) [GL2-W2.5]
# REVIEW same wart as \w w/rt extra delimiters. let's see what we run into.
#
#
#

module Troff
  def esc_x(s)
    #warn "not yet tokenized - #{__callee__}"
    quotechar = Regexp.quote(get_char(s))
    req_str = s.sub(/^#{quotechar}(.*)#{quotechar}$/, '\1')
    #(_, full_esc, quote_char, req_str) = Regexp.last_match.to_a

    space = to_u(req_str).to_i	# REVIEW: default unit??
    unless space.zero?
      warn "trying to \\x#{space} - (\\#{req_str.inspect})"
      container = Text.new(font: @current_block.text.last.font.dup, style: @current_block.text.last.style.dup)
      container.style.css[ space > 0 ? :padding_top : :padding_bottom] = to_em("#{space}u") + 'em'
      container.text << s[0]
      @current_block << container
      @current_block << Text.new(font: @current_block.text[-2].font.dup, style: @current_block.text[-2].style.dup)
      #s[1..-1]
    end
    ''
  end
end
