# selenium.rb
# ---------------
#    Troff \w support
# ---------------
#
# frozen_string_literal: true
#

class Troff

  def self.report_selenium_cache_stats
    warn @@webdriver.cache_stats
  end

  private

  def typesetter_width(fragment)
    to_u(@@webdriver.width(fragment.to_html).to_s, default_unit: 'px')
  end

end
