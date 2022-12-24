# ec.rb
# -------------
#   troff
# -------------
#
#   §10.1
#
# Request       Initial   If no     Notes   Explanation
#  form          value    argument
#
# .ec c         \         \         -       Set escape character to \, or to c, if given.
#
# .eo           on        -         -       Turn escape mechanism off.
#

module Troff
  def req_ec(argstr = '', breaking: nil)
    chr = argstr[0] || '\\'
    @state[:escape_char] = chr
  end

  def req_eo(_argstr = '', breaking: nil)
    warn "disabling escape mechanism"
    @state[:escape_char] = nil
    true
  end

  def xinit_ec
    req_ec
    true
  end
end
