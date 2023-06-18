# util.rb
# ---------------
#    Troff utility routines
# ---------------
#

require 'selenium-webdriver'

module Troff

  private

  def typesetter_width(fragment)
    to_u(@@webdriver.get_width(fragment.to_html).to_s, default_unit: 'px')
  end

  def xinit_selenium_cache
    @@webdriver.define_singleton_method :get_width do |fragment|
      @selenium_cache ||= {hits: 0, misses: 0, calls: 0}
      @selenium_cache[fragment] ||= {}
      @selenium_cache[:calls] += 1
      if @selenium_cache[fragment].has_key? :width
        @selenium_cache[:hits] += 1
        @selenium_cache[fragment][:width]
      else
        @selenium_cache[:misses] += 1
        get fragment
        begin
          @selenium_cache[fragment][:width] = find_element(id: 'selenium').size.width
        rescue Selenium::WebDriver::Error::NoSuchElementError => e
          warn e
          @selenium_cache[fragment][:width] = 'NaN' # REVIEW: side effects - returning nil - but what string makes sense?
        end
      end
    end
    # there won't be a @selenium_cache if we never used the webdriver
    @@webdriver.define_singleton_method :hits do
      @selenium_cache&.[](:hits) || 0
    end
    @@webdriver.define_singleton_method :misses do
      @selenium_cache&.[](:misses) || 0
    end
    @@webdriver.define_singleton_method :calls do
      @selenium_cache&.[](:calls) || 0
    end
  end

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
      # simple cache for webdriver.get method
      #  TODO
      #  - doesn't actually work; .get manipulates internal state of webdriver object;
      #    need to later be able to do .find_element (e.g. during tabs) and this won't
      #    work correctly if we've not actually done the .get
      #    the cache needs to correctly manipulate the internal state of @@webdriver,
      #    not just return the data
      #
      #@@webdriver.define_singleton_method :get do |html|
      #  @selenium_cache ||= {hits: 0, misses: 0, calls: 0}
      #  @selenium_cache[:calls] += 1
      #  if @selenium_cache.has_key?(html)
      #    @selenium_cache[:hits] += 1
      #    @selenium_cache[html]
      #  else
      #    @selenium_cache[:misses] += 1
      #    @selenium_cache[html] = super(html)
      #  end
      #end
      #@@webdriver.define_singleton_method :hits do
      #  @selenium_cache[:hits]
      #end
      #@@webdriver.define_singleton_method :misses do
      #  @selenium_cache[:misses]
      #end
      #@@webdriver.define_singleton_method :calls do
      #  @selenium_cache[:calls]
      #end
      xinit_selenium_cache
    end
  end

  def self.report_selenium_cache_stats
    return nil unless @@webdriver.respond_to?(:calls)
    warn "selenium cache stats: #{@@webdriver.hits}/#{@@webdriver.misses} (total: #{@@webdriver.calls})"
  rescue NameError # we didn't initialize a webdriver
    nil
  end

  def self.webdriver
    @@webdriver
  end

  alias_method :xinit_selenium, :xinit_selenium_chrome
end
