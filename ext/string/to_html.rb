# frozen_string_literal: true
#
# this method is instrumental, not necessarily well-conceived
#

# TODO ugh avoid
class String
  alias_method :to_html, :to_s
end

