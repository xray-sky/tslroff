# B.rb
# -------------
#   troff
# -------------
#
#   applies basic type styles (B, I)
#	plus alternating type styles (BR, IR, BI, IB, etc.)
#
# TODO: this (and .SB, .SM) have got to be made safe for e.g.
# sh.1 [GL2-W2.5] -> .B has conditional following
#

module Troff
  %w[B I R].each do |a|
    define_method "req_#{a}".to_sym do |args|
      args.any? or args = [@lines.next]
      apply do
        @current_block.text.last.font.face = case a
                                             when 'B' then :bold
                                             when 'I' then :italic
                                             when 'R' then :regular
                                             end
        unescape(args.join(' '))
      end
      apply { @current_block.text.last.font.face = :regular } unless a == 'R'
    end
  end

  %w[B I R].permutation(2).each do |a, b|
    define_method "req_#{a + b}".to_sym do |args|
      styles = [a, b]
      args.each_with_index do |arg, i|
        send("req_#{styles[i % 2]}".to_sym, [arg])
      end
    end
  end
end