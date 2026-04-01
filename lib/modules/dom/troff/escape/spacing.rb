# spacing.rb
# -------------
#   troff
# -------------
#
#   \o - overstrike
#   \w - width function
#   \x - extra line space
#   \z - non-spacing character
#

class Troff

#   \o - overstrike
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

  def esc_o(s)
    quotechar = Regexp.quote(get_char(s))
    req_str = s.sub(/^#{quotechar}(.*)#{quotechar}$/, '\1')
    pile = Block::Bare.new(text: Text.new(font: @current_block.terminal_font.dup, style: @current_block.terminal_text_style.dup))
    until req_str.empty?
      chr = req_str.slice!(0, get_char(req_str).length)
      unescape chr, output: pile
      pile << Text.new(font: pile.terminal_font.dup, style: pile.terminal_text_style.dup) unless pile.terminal_text_obj.empty?
    end
    pile.text.pop # nuke the last empty Text obj
    Overstrike.new(chars: pile.text, font: pile.text.first.font.dup, style: pile.text.first.style.dup)#.tap { |n| warn "inserted overstrike #{n.inspect}" }
  end

#   \w - width function
#
# The width function \w'string' generates the numerical width of string (in basic
# units). Size and font changes may be safely embedded in string, and will not affect
# the current environment. For example, .ti -\w'1. 'u could be used to temporarily
# indent leftward a distance equal to the size of the string "1. ".
#
# The width function also sets three number registers. The registers st and sb are
# set respectively to the highest and lowest extent of string relative to the baseline;
# then, for example, the total height of the string is \n(stu-\n(sbu. In troff the
# number register .ct is set to a value between 0 and 3; 0 means that all of the
# characters in string were short lower case characters without descenders (like "e");
# 1 means that at least one character has a descender (like "y"); 2 means that at least
# one character is tall (like "H"); and 3 means that both tall characters and characters
# with descenders are present.
#
# observed variations
# \w'\fB/usr/share/groff/font/devps/download'u+2n
# \w'\f(CWdelete array[expression]'u
# \w'\fBsprintf(\^\fIfmt\fB\^, \fIexpr-list\^\fB)\fR'u+1n
# \w'\(bu'u+1n
# \w'.SM KRB5CCNAME\ \ 'u      <- REVIEW what up with this
# \w'.eh \'x\'y\'z\'  'u       <- REVIEW ...or this?
# \w^B\\$1\\*(s1\\$2\\*(s2^Bu	 <- TODO this might cause problems - where was it from?? was a .tr in effect?
#                                       the manual suggests this might be illegal somehow?
#                                       -- the answer is in §10.1 -- "In addition, STX, ETX, ENQ, ACK, and BEL
#                                       may be used as delimiters or translated into a graphic with .tr. [...]
#                                       troff normally passes none of these characters to its output; nroff
#                                       passes the BEL character. All others are ignored."
#                                       so that's ^B, ^C, ^E, ^F and ^G, and these work with .if too
#                                       -- though sh(1) [GL2-W2.5] has \h@-.3m@ with no .tr in effect
#                                          and so does bcopy(1m) - so I'll add @ to the delims? REVIEW
#                                          and hp(1) uses `; mv(5) uses #
#
# seems [[ \w'word'+1n ]] actually gives [[ 96+1n ]] and it's
# up to whatever request or escape to evaluate the expression
#
# TODO "will not affect the current environment"
# TODO set number registers -- REVIEW is it necessary? (is it used in practice)
# REVIEW i'm in big trouble if I ever get a \w with a tab in it (why did I think this? seems ok maybe)
#

  def esc_w(s)
    quotechar = Regexp.quote(get_char(s))
    req_str = s.sub(/^#{quotechar}(.*)#{quotechar}$/, '\1')

    # get a manipulable block that can be rendered without leaving anything in the output stream
    selenium = Block::Selenium.new
    unescape(req_str, output: selenium)
    typesetter_width(selenium)
  end

  # TODO I want a way to instantiate these, but with a warning so I can note
  #      the use of unimplemented features vs. garbage input
  #def init_w
  #  @register['st'] = Troff::Register.new()
  #  @register['sb'] = Troff::Register.new()
  #  @register['ct'] = Troff::Register.new()
  #end

#   \x - extra line space
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
# TODO how to use the .a register??
#
# REVIEW '0' arg - see spline(1g) [GL2-W2.5]
# REVIEW same wart as \w w/rt extra delimiters. let's see what we run into.
#

  def esc_x(s)
    quotechar = Regexp.quote(get_char(s))
    req_str = s.sub(/^#{quotechar}(.*)#{quotechar}$/, '\1')

    space = to_u(req_str, default_unit: 'v').to_i
    return String.new if space.zero?

    warn "trying to \\x#{space} - (\\#{req_str.inspect})"
    #container = Text.new(font: output.terminal_font.dup, style: output.terminal_text_style.dup)
    #container.style.css[ space > 0 ? :padding_top : :padding_bottom] = to_em("#{space}u") + 'em'
    #container.text << s[0]
    #output << container
    #output << Text.new(font: output.text[-2].font.dup, style: output.text[-2].style.dup)
    ExtraLineSpace.new(height: space, font: @current_block.terminal_font.dup, style: @current_block.terminal_text_style.dup)
  end

#   \z - non-spacing character
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
