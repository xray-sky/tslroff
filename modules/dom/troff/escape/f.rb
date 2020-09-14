# f.rb
# -------------
#   troff
# -------------
#
#   definition of the \f (change font) escape
#
#   §2.2
#
# \fN, \fx
#
# it is not necessary to change to the Special Font; characters on that font are handled
# automatically.
#
# TODO \f(xx
#      a request for a named but not mounted font causes it to be mounted on fp 0
#      fp 0 is otherwise inaccessible
#
#      the position of the current font is available in the read-only number
#      register, .f
#
#      \f(BI (bold-italic) in scsiformat(8c) [AOS 4.3]
#
module Troff
  def esc_f(s)
    esc = Regexp.quote(@state[:escape_char])   # handle \f\P wart in ftp.1c [GL2-W2.5]
    #if s.match(/^f#{esc}?([1-9BIPRS])/)
    if s.match(/^f#{esc}?([1-9BIPR])/)
      (esc_seq, font_req) = Regexp.last_match.to_a
      req_ft(font_req)
      s.sub(/#{Regexp.quote(esc_seq)}/, '')
    else
      warn "unselected font face #{s[0..1]} from #{s[2..-1]}"
      s[2..-1]
    end
  end
end
