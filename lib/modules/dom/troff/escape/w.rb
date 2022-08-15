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
# Tried a bunch of stuff to get faster results through selenium.
#  * specify user profile, instead of letting it generate one every time
#  * explicitly set various browser cache options
#  * get doc once, use javascript to replace element (to prevent repeated download/parse of css)
#  * find element with css selector instead of by id
#  ...nothing helped.
#
# TODO "will not affect the current environment"
# TODO set number registers -- REVIEW is it necessary? (is it used in practice)
# REVIEW i'm in big trouble if I ever get a \w with a tab in it
#

module Troff
  def esc_w(s)
    quotechar = Regexp.quote(get_char(s))
    req_str = s.sub(/^#{quotechar}(.*)#{quotechar}$/, '\1')

    # get a manipulable block that can be rendered without leaving anything in the output stream
    selenium = Block::Selenium.new
    unescape(req_str, output: selenium)
    @@webdriver.get selenium.to_html
    #@@webdriver.execute_cdp('CSS.enable', {}) it does nothing
    begin
      width = to_u(@@webdriver.find_element(id: 'selenium').size.width.to_s, default_unit: 'px')#.to_i
      # do i really need to append 'u' here? there was a place. nroff? tbl? REVIEW what happened
    rescue Selenium::WebDriver::Error::NoSuchElementError => e
      warn e
      'NaN' # REVIEW: side effects - returning nil - but what string makes sense?
    end
  end

  # TODO I want a way to instantiate these, but with a warning so I can note
  #      the use of unimplemented features vs. garbage input
  #def init_w
  #  @register['st'] = Troff::Register.new()
  #  @register['sb'] = Troff::Register.new()
  #  @register['ct'] = Troff::Register.new()
  #end

  # safari can't run headless and is about 3x slower than headless chromedriver
  # otherwise the reults appear identical (at first glance)
  def xinit_selenium_safari
    unless defined? @@webdriver
      safari_opts = Selenium::WebDriver::Safari::Options.new
      #safari_opts.add_argument('--headless')
      @@webdriver = Selenium::WebDriver.for(:safari, options: safari_opts)
      # calibrate Selenium (dimension results are in px)
      @@webdriver.get('data:text/html;charset=utf-8,<div id="calibrate" style="width:1in;"></div>')
      @@pixels_per_inch = @@webdriver.find_element(id: 'calibrate').size.width
    end
  end

  # chromedriver without --headless is ~20% slower than safari
  def xinit_selenium_chrome
    unless defined? @@webdriver
      chrome_opts = Selenium::WebDriver::Chrome::Options.new
      chrome_opts.add_argument('--headless')
      # look for installed Chrome browser location
      chrome_bin = %w( ~/bin/chrome    ~/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome
                       /usr/bin/chrome /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome ).
                   map { |p| File.expand_path(p) }.find { |b| File.executable?(b) }
      chrome_opts.binary = chrome_bin
      @@webdriver = Selenium::WebDriver.for(:chrome, options: chrome_opts)
      # calibrate Selenium (dimension results are in px)
      @@webdriver.get('data:text/html;charset=utf-8,<div id="calibrate" style="width:1in;"></div>')
      @@pixels_per_inch = @@webdriver.find_element(id: 'calibrate').size.width
    end
  end

  alias_method :xinit_selenium, :xinit_selenium_chrome
end
