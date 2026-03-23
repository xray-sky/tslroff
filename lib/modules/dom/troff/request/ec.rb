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

class Troff
  def ec(argstr = '', breaking: nil)
    chr = argstr[0] || '\\'
    @escape_character = chr
  end

  def eo(_argstr = '', breaking: nil)
    warn "disabling escape mechanism"
    @escape_character = nil
    true
  end

  def xinit_ec
    ec
    true
  end
end
