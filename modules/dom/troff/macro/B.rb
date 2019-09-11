# B.rb
# -------------
#   troff
# -------------
#
#   applies basic type styles (B, I)
#	plus alternating type styles (BR, IR, BI, IB, etc.)
#

module Troff
  %w[B I].each do |a|
    define_method "req_#{a}".to_sym do |*args|
      unescape('\f' + @state[:fpmap][a].to_s)
      if args
        unescape(args.join(' '))
        finalize_B
      else
        req_it(1, :finalize_B)
      end
    end
  end

  %w[B I R].permutation(2).each do |a, b|
    define_method "req_#{a + b}".to_sym do |*args|
      styles = [@state[:fpmap][a], @state[:fpmap][b]]
      unescape(args.each_with_index.map do |arg, i|
                 '\f' + styles[i % 2].to_s + arg
               end.join)
      process_input_traps
    end
  end

  # the same, whether .B or .I
  def finalize_B
    unescape('\f1')
    process_input_traps
  end

end
