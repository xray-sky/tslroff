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
  
  def req_B ( args )
    @current_block << Text.new(:text => args.join(" "), :font => Font.new(:face => :bold))
    @current_block << Text.new
  end

  def req_I ( args )
    @current_block << Text.new(:text => args.join(" "), :font => Font.new(:face => :italic))
    @current_block << Text.new
  end

  def req_R ( args )
    @current_block << Text.new(:text => args.join(" "), :font => Font.new(:face => :regular))
    @current_block << Text.new
  end

end