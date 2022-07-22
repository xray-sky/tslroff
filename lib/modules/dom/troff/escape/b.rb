# b.rb
# -------------
#   troff
# -------------
#
#   definition of the \b (overstrike) escape
#
#

module Troff
  def esc_b(s)
    quotechar = Regexp.quote(get_char(s))
    req_str = s.sub(/^#{quotechar}(.*)#{quotechar}$/, '\1')
    warn "\\b trying to draw brackets #{req_str.inspect}"
    unescape(req_str)
  end
end
