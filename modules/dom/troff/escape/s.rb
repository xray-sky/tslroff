# s.rb
# -------------
#   troff
# -------------
#
#   definition of the \s (change font size) escape
#

module Troff
  def esc_s(s)
    # if the char after \s is 0, +, or -, it MUST be a one-digit size request.
    # TODO: wrong. see §2.3 (Character Size)
    #       "...double-digit increments or decrements are expressed as \s±NN"
    # (though see: adb.1, term.5 [GL2-W2.5])
    # \s0 is the case for adb.1, so this is no problem
    # but term.5 has \s+12631, where 2631 is clearly meant to be printing (plus other examples)

    if s.match(/^s(0|(?:[-+123]?\d))/)
      (esc_seq, size_req) = Regexp.last_match.to_a
      req_ps(size_req)
      s.sub(/#{Regexp.quote(esc_seq)}/, '')
    else
      warn "unselected font size #{s[0..1]} from #{s[2..-1]}"
      s[2..-1]
    end
  end
end
