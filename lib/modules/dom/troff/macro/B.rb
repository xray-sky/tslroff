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
      #unescape('\f' + @state[:fpmap][a].to_s)
      unescape('\f' + @state[:fonts].index(a).to_s)
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
      #styles = [@state[:fpmap][a], @state[:fpmap][b]]
      styles = [@state[:fonts].index(a), @state[:fonts].index(b)]
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
    # evidence size reset is not right. wish I'd left a note why I thought it needed doing.
    # SunOS 5.5.1 tmac.an does it, that's why. REVIEW do they all? GL1 W2.1 does.
    # that's probably good enough to say, "yes".
    # but it is NOT correct in sample table 7 (which perhaps doesn't use tmac.an)
    req_ps(Font.defaultsize)
  end

end
