# frozen_string_literal: true
#
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
# on pages with lots of tabs.
#
#     e.g. SunPHIGS 1.1 runs 15min to process, without cache
#          with the cache, appx. half that.
#
#          but I'm seeing problems sometimes with the cache apparently being poisoned by
#          results where the CSS did not load correctly?
#
# In general: Chrome without --headless is about 20% slower than Safari,
#             Safari about 3x slower than Chrome with --headless

require 'zlib'
require 'selenium-webdriver'

class WebDriver

  attr_reader :browser, :ppi

  def initialize(driver: :chrome, options: nil, backing_store: nil)
    options || case driver
               when :chrome
                 options = Selenium::WebDriver::Chrome::Options.new
                 options.add_argument('--headless')
                 options.binary = chrome_binary
               when :safari
                 options = Selenium::WebDriver::Safari::Options.new
                 # Safari can't run headless
                 #options.add_argument('--headless')
               end

    @browser = Selenium::WebDriver.for driver, options: options
    @ppi = calibrate '1in'

    @cache_hits = 0
    @cache_misses = 0
    @cache_calls = 0
    @cache_backing_file = backing_store
    backing_store ? restore_cache(backing_store) : @cache = {}
  end

  def width(block)
    @cache_calls += 1
    #md5 = Digest::MD5.hexdigest fragment
    #c = @cache[md5] ||= {}
    c = @cache[block.fragment] ||= {}
    return c[:width] if c[:width] and @cache_hits += 1

    @cache_misses += 1
    browser.get block.to_html
    c[:width] = browser.find_element(id: 'selenium').size.width

  rescue Selenium::WebDriver::Error::NoSuchElementError => e
    warn e
    'NaN'  # REVIEW: side effects - returning nil - but what string makes sense?
  end

  def reset_cache
    @cache = {}
    reset_cache_stats
  end

  def reset_cache_stats
    @cache_hits = 0
    @cache_misses = 0
    @cache_calls = 0
  end

  def cache_stats
    "Selenium cache stats: #{@cache_hits} hits, #{@cache_misses} misses (total calls: #{@cache_calls} entries: #{@cache.count})"
  end

  # REVIEW what if ppi changes - I think it's ok because we're storing typesetter units
  #        new entries will have been scaled accordingly, already. if the typesetter
  #        basic unit changes, THEN we'll be in trouble.

  def persist_cache
    return unless @cache_backing_file
    f = Zlib::GzipWriter.new File.new(@cache_backing_file, 'w')
    f.write Marshal.dump(@cache)
    f.close
  end

  private

  def calibrate(width)
    @browser.get %(data:text/html;charset=utf-8,<div id="calibrate" style="width:#{width};"></div>)
    @browser.find_element(id: 'calibrate').size.width
  end

  def chrome_binary
    %w[
      ~/bin/chrome
      ~/Unix/bin/chrome
      ~/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome
      /usr/bin/chrome
      /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome
    ].map { |p| File.expand_path(p) }.find { |b| File.executable?(b) }
  end

  def restore_cache(file)
    f = Zlib::GzipReader.open file
    @cache = Marshal.load f.read
    f.close
    puts "Webdriver: restored #{@cache.count} entries to cache"
  rescue IOError, SystemCallError, Zlib::GzipFile::Error => e
    warn "failed to load cache: #{e.message}"
    @cache = {}
  end
end
