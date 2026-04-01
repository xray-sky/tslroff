# frozen_string_literal: true
#
# control_chars.rb
# -------------
#   troff
# -------------
#
#   §10.1, §10.4
#
#    Changes must be compatible with the design of macros used in the span of the change,
#    especially trap-invoked macros.
#

class Troff
  # Request  Initial  If no     Notes   Explanation
  #  form     value   argument
  #
  # .c2 c     '       '         E       The no-break control character is set to c, or reset to "'"

  def c2(argstr = '', breaking: nil)
    chr = argstr.empty? ? %(') : argstr[0]
    @c2 = chr
    true
  end

  # Request  Initial  If no     Notes   Explanation
  #  form     value   argument
  #
  # .cc c     .       .         E       The basic control character is set to c, or reset to "."

  def cc(argstr = '', breaking: nil)
    chr = argstr.empty? ? %(.) : argstr[0]
    @cc = chr
    true
  end

  # Request       Initial   If no     Notes   Explanation
  #  form          value    argument
  #
  # .ec c         \         \         -       Set escape character to \, or to c, if given.

  def ec(argstr = '', breaking: nil)
    chr = argstr[0] || '\\'
    @resc = Regexp.escape chr
    @escape_character = chr
  end

  # Request       Initial   If no     Notes   Explanation
  #  form          value    argument
  #
  # .eo           on        -         -       Turn escape mechanism off.

  def eo(_argstr = '', breaking: nil)
    warn "disabling escape mechanism"
    @escape_character = nil
    true
  end

  def init_cc
    cc
    c2
  end

  def xinit_ec
    ec
    true
  end
end
