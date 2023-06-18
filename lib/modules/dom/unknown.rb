# unknown.rb
#
# unknown source magic
# defer to platform overrides
#
# REVIEW still necessary?
#

module Unknown
  def self.extended(k)
    warn "!!! extended doctype ::Unknown"
  end
end
