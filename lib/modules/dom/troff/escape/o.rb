# o.rb
# -------------
#   troff
# -------------
#
#   definition of the \o (overstrike) escape
#
# Automatically centered overstriking of up to 9 characters is provided by the
# overstrike function \o'string'. The characters in string are overprinted with
# centers aligned; the total width is that of the widest character. string should
# not contain local vertical motion. As examples, \o'e\'' produces é
# \o'\(mo\(sl' produces ∉
#
#

module Troff
  def esc_o(s)
    quotechar = Regexp.quote(get_char(s))
    req_str = s.sub(/^#{quotechar}(.*)#{quotechar}$/, '\1')
    warn "\\o trying to overstrike #{req_str.inspect}"
    unescape(req_str)
    ''
=begin
this is totally f***ed because there can be font changes involved here
\o'\f2n\f1\(rn' -- from factor(1) [SunOS 5.5.1] (bold n, with an overbar (extended radical for '\(sr'))
ha! but it fails in psroff too - no overstrike.
    pile = []
    begin
      pile << s.slice!(0, get_char(s).length)
    end until s.empty?
    warn "\\o overstriking >2 chars (#{pile.inspect})" if pile.length > 2
    pile = pile.join("\017")
    "&roffctl_overstrike(#{pile});"
=end
  end
end
