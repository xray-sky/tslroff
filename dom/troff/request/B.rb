# B.rb
# -------------
#   troff
# -------------
#
#   applies basic type styles (B, I)
#	plus alternating type styles (BR, IR, BI, IB, etc.)
#

module Troff

  # H4X - revisit 'args' below when they're actually parsed into an array sooner.
  
  [ "B", "I", "R" ].each do |a|
    [ "B", "I", "R" ].each do |b|
      unless a == b
        define_method "req_#{a+b}".to_sym do |args|
          styles = [ a, b ]
          args.split.each_with_index do |arg, i|
            self.send("req_#{styles[i%2]}".to_sym, arg)
          end
        end
      end
    end
  end
  
  def req_B ( args )
    @current_block.append(TaggedText.new(args, {:b => true}))
  end

  def req_I ( args )
    @current_block.append(TaggedText.new(args, {:i => true}))
  end

  def req_R ( args )
    @current_block.append(TaggedText.new(args))
  end

end