# webdriver.rb
# ---------------
#    cached Selenium WebDriver wrapper class
# ---------------
#
# Tried a bunch of stuff to get faster results through selenium.
#  * specify user profile, instead of letting it generate one every time
#  * explicitly set various browser cache options
#  * get doc once, use javascript to replace element (to prevent repeated download/parse of css)
#  * find element with css selector instead of by id
#  ...nothing really helped.
#
# Implemented a selenium answer cache. Even if it isn't persisted it ought to pay dividends
# on pages with lots of tabs
#
#     e.g. SunPHIGS 1.1 runs 15min to process, without cache
#          with the cache, appx. half that.
#
#          but I'm seeing problems sometimes with the cache apparently being poisoned by
#          results where the CSS did not load correctly?
#
# In general: Chrome without --headless is about 20% slower than Safari,
#             Safari about 3x slower than Chrome with --headless

require 'selenium-webdriver'

class WebDriver

  attr_reader :ppi

  def initialize(driver: :chrome, options: nil)
    case driver
    when :chrome
      unless options
        options = Selenium::WebDriver::Chrome::Options.new
        options.add_argument('--headless')
        options.binary = chrome_binary
      end
    when :safari
      unless options
        options = Selenium::WebDriver::Safari::Options.new
        # Safari can't run headless
        #options.add_argument('--headless')
      end
    end

    @browser = Selenium::WebDriver.for driver, options: options
    @ppi = calibrate '1in'

    @cache = {}
    @cache_hits = 0
    @cache_misses = 0
    @cache_calls = 0
  end

  def width(fragment)
    @cache_calls += 1
    c = @cache[fragment] ||= {}
    return c[:width] if c[:width] and @cache_hits += 1

    @cache_misses += 1
    @browser.get fragment
    begin
      c[:width] = @browser.find_element(id: 'selenium').size.width
    rescue Selenium::WebDriver::Error::NoSuchElementError => e
      warn e
      'NaN'  # REVIEW: side effects - returning nil - but what string makes sense?
    end
  end

  def reset_cache
    cache = {}
    reset_cache_stats
  end

  def reset_cache_stats
    @cache_hits = 0
    @cache_misses = 0
    @cache_calls = 0
  end

  def cache_stats
    "Selenium cache stats: #{@cache_hits} hits, #{@cache_misses} misses (total: #{@cache_calls})"
  end

  private

  def chrome_binary
    %w[
      ~/bin/chrome
      ~/Unix/bin/chrome
      ~/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome
      /usr/bin/chrome
      /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome
    ].map { |p| File.expand_path(p) }
    .find { |b| File.executable?(b) }
  end

  def calibrate(width)
    @browser.get %(data:text/html;charset=utf-8,<div id="calibrate" style="width:#{width};"></div>)
    @browser.find_element(id: 'calibrate').size.width
  end

end
