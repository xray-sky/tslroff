# (.rb
# -------------
#   troff
# -------------
#
#   basic definitions of the \* (named string) escape
#

module Troff
  def esc_star(s)
    if s.match(/^\*(\(..|.)/)
      (esc_seq, schar) = Regexp.last_match.to_a 
      str = @state[:named_strings][schar.to_sym] || "||#{schar}||"
      case str.class.name
      when 'String' then @current_block << str
      when 'Block'
        str.type == :bare or raise RuntimeError "encountered non-bare block in \\* (#{str.inspect})"
        @current_block << str
      end        
      s.sub(/#{Regexp.quote(esc_seq)}/, '')
    else
      %(<span style="color:green;">named string #{s[0..1]}</span>#{s[2..-1]})
    end
  end
end