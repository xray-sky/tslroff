# B.rb
# -------------
#   troff
# -------------
#
#   .B text			Make text bold.
#   .I text			Make text italic.
#   .RI a b			Concatenate roman a with italic b, and alternate these two fonts for
#                   up to six arguments. Similar macros alternate between any two of
#                   roman, italic, and bold:   .IR  .RB  .BR  .IB  .BI
#
#   tmac.an defines behavior where a shift out of I inserts \^ except after the last arg
#


module Troff
  %w[B I].each do |a|
    define_method "req_#{a}".to_sym do |*args|
      unescape('\f' + @state[:fpmap][a].to_s)
      if args.any?
        unescape(args.join(' '))
        finalize_B
      else
        req_it('1', :finalize_B)
      end
    end
  end

  %w[B I R].permutation(2).each do |a, b|
    define_method "req_#{a + b}".to_sym do |*args|
      styles = [@state[:fpmap][a], @state[:fpmap][b]]
      unescape(args.each_with_index.map do |arg, i|
                 p = styles[i % 2].to_s
                 '\f' + p + arg + "#{'\^' if p == 'I' and !peek[0].empty?}"
               end.join)
      finalize_B
    end
  end

  # the same, whether .B or .I
  def finalize_B
    unescape('\f1')
    req_ps(Font.defaultsize)
  end

end
