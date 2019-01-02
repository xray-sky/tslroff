# f.rb
# -------------
#   troff
# -------------
#
#   definition of the \f (change font) escape
#

module Troff
  def esc_f(s)
    esc = Regexp.quote(@state[:escape_char])   # handle \f\P wart in ftp.1c [GL2-W2.5]
    if s.match(/^f#{esc}?([1-9BIPR])/)
      (esc_seq, font_req) = Regexp.last_match.to_a
      case font_req
      when /\d/ then apply { @current_block.text.last.font = @state[:font_pos][font_req.to_i].dup } && @current_block.text.last.font.size = @state[:register]['.s'].value
      when 'R'  then apply { @current_block.text.last.font.face = :regular }
      when 'B'  then apply { @current_block.text.last.font.face = :bold }
      when 'I'  then apply { @current_block.text.last.font.face = :italic }
      when 'P'
        # if the block is newly opened and we encounter a line like \f2something\fP, 
        # there won't be a @current_block.text[-2] and we'll end up referencing garbage
        f = if @current_block.text.count > 1
          @current_block.text[-2].font.face
        else
          # REVIEW: is reality more sophisticated than this?
          :regular
        end
        @current_block << Text.new(font: @current_block.text.last.font.dup,
                                   style: @current_block.text.last.style.dup)
        @current_block.text.last.font.face = f
      end
      s.sub(/#{Regexp.quote(esc_seq)}/, '')
    else
      warn "unselected font face #{s[0..1]} from #{s[2..-1]}"
      s[2..-1]
    end
  end
end