# w.rb
# -------------
#   troff
# -------------
#
#   definition of the \w (width function) escape
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
# TODO "will not affect the current environment"
# TODO set number registers -- REVIEW is it necessary? (is it used in practice)
# REVIEW i'm in big trouble if I ever get a \w with a tab in it (why did I think this? seems ok maybe)
#

module Troff
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

end
