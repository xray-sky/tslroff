# hc.rb
# -------------
#   troff
# -------------
#
#   §13
#
# Request       Initial   If no     Notes   Explanation
#  form          value    argument
#
# .hc c         \%        \%         E      Hyphenation indicator character is set to c
#                                           or the default \%. The indicator does not
#                                           appear in the output.
#

module Troff

  def req_hc(chr = "\\%")
    warn "changing discretionary hyphen to #{chr.inspect}" unless chr == "\\%"
    @state[:hyphenation_character] = chr
  end

  def init_hc
    req_hc
  end

end
