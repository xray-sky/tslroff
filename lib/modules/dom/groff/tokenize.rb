# methods for tokenizing input lines
#
#  override Troff methods
#  main difference seems to be the inclusion of names longer than two chars, enclosed in []
#
# these methods are _not_ destructive of s
#

module Groff

# return one definition
# either a single character, or a two-character definition preceeded by (
# as accepted by \f, \g, \k, \n, \*, \(, etc.
# \n may have a + or - in front of the register name

  def get_def_str(s)
    req = get_char(s)
    n = 1
    req << get_char(s[n]) and n = 2 if %[- +].include? req
    req << get_char(s[n..-1], count: 2) if req.end_with? '('
    req << get_enclosed_def_str(s) if req.end_with? '['
    req
  end

  def get_enclosed_def_str(s)
    req = ''
    until req.end_with? ']'
      req << get_char(s)
    end
    req
  end

end
