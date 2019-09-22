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
# observed variations
# \w'\fB/usr/share/groff/font/devps/download'u+2n
# \w'\f(CWdelete array[expression]'u
# \w'\fBsprintf(\^\fIfmt\fB\^, \fIexpr-list\^\fB)\fR'u+1n
# \w'\(bu'u+1n
# \w'.SM KRB5CCNAME\ \ 'u       <- REVIEW what up with this
# \w'.eh \'x\'y\'z\'  'u        <- REVIEW ...or this?
# \w^B\\$1\\*(s1\\$2\\*(s2^Bu	<- TODO this might cause problems - where was it from?? was a .tr in effect?
#                                       the manual suggests this might be illegal somehow?
#
# TOOD: this sort of construct -- [GL2-W2.5] adb.1
# .tr ~"
# .RS "\w'\f3~...~\f1\ 0\^\ \ \ \ \ 'u"
# .tr ~~


module Troff
  def esc_w(s)
    esc = Regexp.quote(@state[:escape_char])
    s.match(/(^w(.)(.+?(#{esc}\2)*)\2)/)
    (_, full_esc, quote_char, req_str) = Regexp.last_match.to_a

    # get a manipulable block that can be rendered without leaving anything in the output stream
    hold_block = @current_block
    @current_block = Block.new(type: :se)

    unescape(req_str)
    @webdriver.get("data:text/html;charset=utf-8,#{@current_block.to_html}")
    width = to_u("#{@webdriver.find_element(id: 'selenium').size.width}px")

    # restore normal output
    @current_block = hold_block

    width.to_s + s.slice(full_esc.length..-1)
  end

  def init_selenium
    chrome_opts = Selenium::WebDriver::Chrome::Options.new
    chrome_opts.add_argument('--headless')
    @webdriver = Selenium::WebDriver.for(:chrome, options: chrome_opts)
    # calibrate Selenium (dimension results are in px)
    @webdriver.get('data:text/html;charset=utf-8,<div id="calibrate" style="width:1in;"></div>')
    @@pixels_per_inch = @webdriver.find_element(id: 'calibrate').size.width
  end

end
