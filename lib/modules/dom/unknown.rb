# unknown.rb
#
# unknown source magic
# defer to platform overrides
#
# frozen_string_literal: true
#
# REVIEW still necessary?
#

module Unknown
  def self.extended(_k)
    warn "!!! extended doctype ::Unknown"
  end
end
