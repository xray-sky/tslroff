# B.rb
# -------------
#   troff
# -------------
#
#   applies basic type styles (B, I)
#	plus alternating type styles (BR, IR, BI, IB, etc.)
#

module Troff

  [ "B", "I", "R" ].each do |a|

    define_method "req_#{a}".to_sym do |args|
      args.any? or args = @lines.next
      self.apply { 
        @current_block.text.last.font.face = case a
          when "B" then :bold
          when "I" then :italic
          when "R" then :regular
        end
        unescape(args.join(" "))
      }
      self.apply { @current_block.text.last.font.face = :regular } unless a == "R"
    end

    [ "B", "I", "R" ].each do |b|

      define_method "req_#{a+b}".to_sym do |args|
        styles = [ a, b ]
        args.each_with_index do |arg, i|
          self.send("req_#{styles[i%2]}".to_sym, [arg])
        end
      end unless a == b

    end

  end

end