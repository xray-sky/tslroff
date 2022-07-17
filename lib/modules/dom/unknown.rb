# unknown.rb
#
# defer to platform overrides

module Unknown
  def source_init
    load_platform_overrides
    load_version_overrides
  end
end
