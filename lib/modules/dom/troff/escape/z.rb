# z.rb
# -------------
#   troff
# -------------
#
#   definition of the \z (non-spacing) escape
#
# XXX get_esc will have given us the next character to overstrike with, even though it's not
# XXX "officially" part of the \z escape
#
# get_esc will have given us the entire remainder of the string, even though it's not
# "officially" part of the \z escape, because we could have non-outputting escapes
# (font changes, vertical shifts) between the non-spacing character and what is printed
#  on top of it.
#
# examples:
#  scanf(3s)  [SunOS 2.0] - \z\fBe\v'1'f\v'-1'\fR"
#  erf(3m)    [SunOS 3.5] - \(is\d\s8\z0\s10\u\u\s8x
#  lgamma(3m) [SunOS 3.5] - \(is\d\s8\z0\s10\u\u\s8\(if
#
# units(1) [SunOS 2.0] uses "\z/\h'\w'*'u'" as a hack to get a / the same width as a *
# so we have a special case to do this, as otherwise the \h will give "alternate results"
#
# TODO
#   loss of all text following overstrike (from get_char/escape)
# √ loss of font changes during overstriking
#   don't use the Overstrike css, as it centers within the overall width.
#     \z is literally zero width. this matters with e.g. \(br
#
#   even this is not the whole story as scanf.3s [SunOS 2.0] uses "\z\fBe\v'1'f\v'-1'\fR"
#   to get a bold 'e' overstruck by vertically-displaced 'f' (...i think) so it's not
#   strictly true that two runs to get_char will cover us.
#   => I guess this is meant to give us the appearance of a two-line paragraph tag.
#      so it is maybe better to fix this as a rewrite and hope we never run into anything like
#      this again. only there's no way to insert the break at rewrite without closing the tag...
#   => our line-height: 0 css hack will totally prevent this from working! (maybe)
#   => also this (currently broken) Overstrike is not setting the output indicator
#
#  more dire straits:
#    erf(3m) [SunOS 3.5] uses "\(is\d\s8\z0\s10\u\u\s8x" to get bounds on an integral
#     => and we are losing the \s8 (the Overstrike is at regular font size)
#     => the page assumes the default font size is \s10 instead of using \s0 (separate issue)
#
#   lgamma(3m) [SunOS 3.5] same issue - "\(is\d\s8\z0\s10\u\u\s8\(if"
#

module Troff
  def esc_z(s)
    pile = Block::Bare.new(text: Text.new(font: @current_block.terminal_font.dup, style: @current_block.terminal_text_style.dup))
=begin
    outchars = 0
    until outchars == 2 do
      chr = s.slice!(0, get_char(s).length)
      warn outchars.zero? ? "\\z trying to output #{chr.inspect} as non-spacing character" : "\\z continuing with #{chr.inspect}"


      unescape chr, output: pile

      if chr.start_with? "\\h"
        width = "#{pile.text.pop.style[:horizontal_shift]}em"
        out = Overstrike.new(chars: [dead_chr], font: @current_block.terminal_font.dup,
                                               style: @current_block.terminal_text_style.dup)
        out.style.css[:width] = width.tap { |n| warn "special case \\z with \\h (#{n})" }
        return out
      end

      if pile.terminal_text_obj.length > 0
        pile << Text.new(font: pile.terminal_font.dup,
                        style: pile.terminal_text_style.dup)
        outchars += 1
      end
    end

    Overstrike.new(chars: pile.text, font: @current_block.terminal_font.dup,
                                    style: @current_block.terminal_text_style.dup)
=end
    while pile.terminal_text_obj.empty?
      chr = s.slice!(0, get_char(s).length)
      warn "\\z trying to output #{chr.inspect} as non-spacing character"
      unescape chr, output: pile
    end
    NonSpacing.new(text: pile.text, font: pile.terminal_font.dup, style: pile.terminal_text_style.dup)
  end
end
