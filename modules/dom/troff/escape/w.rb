# e.rb
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
# TODO: set number registers
# REVIEW: is it necessary? (is it used in practice)
#
# TODO: actually render it and get something better than an estimate
#       https://dev.to/mscccc/creating-images-with-ruby--htmlcss-api-16g4
#
# observed variations
# \w'\fB/usr/share/groff/font/devps/download'u+2n
# \w'\f(CWdelete array[expression]'u
# \w'\fBsprintf(\^\fIfmt\fB\^, \fIexpr-list\^\fB)\fR'u+1n
# \w'\(bu'u+1n
# \w'.SM KRB5CCNAME\ \ 'u
# \w'.eh \'x\'y\'z\'  'u
# \w^B\\$1\\*(s1\\$2\\*(s2^Bu	<- TODO this might cause problems - where was it from?? was a .tr in effect?
#

module Troff
  def esc_w(s)
  warn "received #{s.inspect}"
    esc = Regexp.quote(@state[:escape_char])
    s.match(/(^w(.)(.+?(#{esc}\2)*)\2)/)
    (_, full_esc, quote_char, req_str) = Regexp.last_match.to_a
    #warn "calculated width of #{Regexp.last_match.inspect}"
    warn "calculated width of #{req_str}"
    req_str.length.to_s + s.slice(full_esc.length..-1) # FIXME: this is totally wrong (chars vs. u)
  end
end
