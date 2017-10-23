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
      when /\d/ then apply { @current_block.text.last.font.face = @state[:font_pos][font_req.to_i] }
      when 'R'  then apply { @current_block.text.last.font.face = :regular }
      when 'B'  then apply { @current_block.text.last.font.face = :bold }
      when 'I'  then apply { @current_block.text.last.font.face = :italic }
      when 'P'  then f = @current_block.text[-2].font.face
                     @current_block << Text.new(font: @current_block.text.last.font.dup,
                                                style: @current_block.text.last.style.dup)
                     @current_block.text.last.font.face = f
      end
      s.sub(/#{esc_seq}/, '')
    else
      "<span style=\"color:blue\">unselected font #{s[0..1]}</span>#{s[2..-1]}"
    end
  end

end
