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
      self.apply { 
        @current_block.text.last.font.face = case a
          when "B" then :bold
          when "I" then :italic
          when "R" then :regular
        end
        @current_block.text.last << args.join(" ")
      }
      self.apply { @current_block.text.last.font.face = :regular } unless a == "R"
    end
    [ "B", "I", "R" ].each do |b|
      unless a == b
        define_method "req_#{a+b}".to_sym do |args|
          styles = [ a, b ]
          args.each_with_index do |arg, i|
            self.send("req_#{styles[i%2]}".to_sym, [arg])
          end
        end
      end
    end
  end

=begin
  def req_B ( args )
    self.apply {
      @current_block.text.last.font.face = :bold
      @current_block.text.last << args.join(" ") 
    }
  end

  def req_I ( args )
    self.apply {
      @current_block.text.last.font.face = :italic
      @current_block.text.last << args.join(" ") 
    }
  end

  def req_R ( args )
    self.apply {
      @current_block.text.last.font.face = :regular
      @current_block.text.last << args.join(" ") 
    }
  end
=end
end