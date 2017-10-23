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
    # (see: adb.1, term.5 [GL2-W2.5])
    if s.match(/^s([-+123]?\d)/) 
      (esc_seq, size_req) = Regexp.last_match.to_a
      size = case size_req
      when '0'          then @current_block.text[-2].font.size
      when /([-+])(\d)/ then @current_block.text.last.font.size.send(Regexp.last_match(1), Regexp.last_match(2).to_i)
      when /\d{1,2}/    then size_req
      end
      @current_block << Text.new(font: @current_block.text.last.font.dup,
                                 style: @current_block.text.last.style.dup)
      @current_block.text.last.font.size = size
      s.sub(/#{Regexp.quote(esc_seq)}/, '')
    else
      "<span style=\"color:blue\">unselected font size #{s[0..1]}</span>#{s[2..-1]}"
    end
  end

end
