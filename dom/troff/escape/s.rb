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
      @state[:register]['.s'] = case size_req
                                when /^\d{1,2}/ then size_req
                                when '0'
                                # if the block is newly opened and we encounter a line 
                                # like \s-2something\s0, there won't be a .text[-2]
                                # and we'll end up referencing garbage
                                f = if @current_block.text.count > 1
                                      @current_block.text[-2].font.size
                                    else
                                      # REVIEW: is reality more sophisticated than this?
                                      Font.defaultsize
                                    end
                                when /^([-+])(\d)/
                                  @current_block.text.last.font.size.send(
                                    Regexp.last_match(1),Regexp.last_match(2).to_i)
                                end
      @current_block << Text.new(font: @current_block.text.last.font.dup,
                                 style: @current_block.text.last.style.dup)
      @current_block.text.last.font.size = @state[:register]['.s']
      s.sub(/#{Regexp.quote(esc_seq)}/, '')
    else
      warn "unselected font size #{s[0..1]} from #{s[2..-1]}"
      s[2..-1]
    end
  end
end
