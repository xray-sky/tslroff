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
# .nh           no hyphen -          E      Automatic hyphenation is turned off.
#
# .hy N         off,N=0   on,N=1     E      Automatic hyphenation is turned on for N≥1,
#                                           or off for N=0. If N=2, last lines (ones that
#                                           will cause a trap) are not hyphenated. For
#                                           N=4 and 8, the last and first two characters
#                                           of a word are not split off. These values are
#                                           additive; i.e. N=14 will invoke all three
#                                           restrictions.
#
# .hc c         \%        \%         E      Hyphenation indicator character is set to c
#                                           or the default \%. The indicator does not
#                                           appear in the output.
#
# .hw word1 ...           ignored           Specify hyphenation points in words with
#                                           embedded minus signs. Versions of a word
#                                           with terminal s are implied (that is, dig-
#                                           it implies dig-its). This list is examined
#                                           initially and after each suffix striping.
#                                           The space available is small - about 128
#                                           characters.
#
#  is '\%' "a character"? does .hc ^ set it to '^' or '\^'?
#   => '.hc ^' appears to add '^' as discretionary hyphen, in addition to '\%'
#   => '.hc \q' appears to add 'q' as a discretionary hyphen, in addition to '\%'.
#      looks like '\q' is parsed into 'q' before assigning it as discretionary hyphen
#   => '.hc \(mu' is apparently possible (TODO?)

module Troff

  def req_hc(argstr = '', breaking: nil)
    chr = get_char argstr # TODO won't correctly handle e.g. '.hc \q'
    if chr
      warn "changing discretionary hyphen to #{chr.inspect}"
      @state[:hyphenation_character] = chr
    else
      warn 'resetting non-default discretionary hyphen'
      @state.delete :hyphenation_character
    end
  end

  def req_nh(_argstr = '', breaking: nil) ; end
  def req_hw(_argstr = '', breaking: nil) ; end
  def req_hy(_argstr = '', breaking: nil) ; end

  #def init_hc
  #  req_hc
  #end

end
