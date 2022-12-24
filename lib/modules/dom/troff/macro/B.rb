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
    define_method a do |*args|
      if args.any?
        req_ft "#{@state[:fonts].index(a)}"
        parse "\\&#{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]}"
        #send '}N' # see note re: \n()E below
        send '}f'
      else
        #req_it('1', '}N')
        req_it '1 }f'
      end
    end
  end

  %w[B I R].permutation(2).each do |a, b|
    define_method "#{a + b}" do |*args|
      parse %(.}S #{@state[:fonts].index(a)} #{@state[:fonts].index(b)} \\& "#{args[0]}" "#{args[1]}" "#{args[2]}" "#{args[3]}" "#{args[4]}" "#{args[5]}")
    end
  end

  define_method '}S' do |*args|
    # special case for shift out of italic
    req_ds "]F #{(args[0] == '2' and !args[4].empty?) ? '\\^' : ''}"
    if !args[3].empty?
      parse %(.}S #{args[1]} #{args[0]} "#{args[2]}\\f#{args[0]}#{args[3]}\\*\(]F" "#{args[4]}" "#{args[5]}" "#{args[6]}" "#{args[7]}" "#{args[8]}")
    else
      parse args[2]
    end
    send '}f'
  end

  # the same, whether .B or .I
  # "handle end of 1-line features"
  # uses \n()E, set by .SH, .SS, .TP, etc.
  # REVIEW do we _need_ to use )E?
  define_method '}N' do |*_args|
    req_br if @register[')E'] > 0
    req_di
    send '}f' if @register[')E'].zero? # .}S
    send '}1' if @register[')E'] == 1 # .TP
    send '}2' if @register[')E'] == 2 # .SH, .SS
  end

  define_method '}f' do |*_args|
    req_ps "#{Font.defaultsize}"
    req_ft '1'
  end

end
