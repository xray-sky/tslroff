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
# is '\%' "a character"? does .hc ^ set it to '^' or '\^'?
#  => '.hc ^' appears to add '^' as discretionary hyphen, in addition to '\%'
#  => '.hc \q' appears to add 'q' as a discretionary hyphen, in addition to '\%'.
#     looks like '\q' is parsed into 'q' before assigning it as discretionary hyphen
#  => '.hc \(mu' is possible (TODO:)

module Troff

  def req_hc(chr = nil)
    if chr
      warn "changing discretionary hyphen to #{chr.inspect}"
      @state[:hyphenation_character] = chr
    else
      warn 'resetting non-default discretionary hyphen'
      @state[:hyphenation_character].delete
    end
  end

  #def init_hc
  #  req_hc
  #end

end
