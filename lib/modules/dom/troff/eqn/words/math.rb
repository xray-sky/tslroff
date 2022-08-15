module Eqn

  def eqn_word(parse_tree)
    m = __callee__.to_s[4..-1] # strip eqn_
    unescape "\\^\\f1#{m}\\fP\\^"
  end

  def eqn_lim(parse_tree) # special case of eqn_word, for adjusting bounds position
    unescape "\\f1lim\\fP"
    gen_eqn [parse_tree.shift]
    @current_block.text[-2].text[-2].style.css[:top] = '-0.33em'
    unescape "\\^"
  end

  def eqn_sqrt(parse_tree)
    rad = ExtendedRadical.new(font: @current_block.text.last.font.dup, style: @current_block.text.last.style.dup)
    gen_eqn [parse_tree.shift], output: rad
    @current_block << rad
  end

  def eqn_over(parse_tree)
    frac = Fraction.new(numerator: Numerator.new(font: @current_block.text.last.font.dup, style: @current_block.text.last.style.dup),
                        denominator: Denominator.new(font: @current_block.text.last.font.dup, style: @current_block.text.last.style.dup),
                        font: @current_block.text.last.font.dup, style: @current_block.text.last.style.dup)
    gen_eqn [parse_tree.shift], output: frac.numerator
    gen_eqn [parse_tree.shift], output: frac.denominator
    @current_block << frac
  end

  def eqn_script(parse_tree)
    obj = case __callee__
          when :eqn_sub then SubScript
          when :eqn_sup then SuperScript
          end

    s = obj.new(font: @current_block.text.last.font.dup, style: @current_block.text.last.style.dup)
    unescape "\\s-3", output: s
    gen_eqn [parse_tree.shift], output: s
    unescape "\\s+3\\|", output: s

    # if we just previously output a superscript, give it a zero width
    # also check text is empty, in case we have something like "int sub 0 sup inf e sup t"
    # -- that last "sup t" will detect the "sup inf" at [-2] and width 0 it.
    @current_block.text[-2].style.css[:width] = 0 if [SuperScript, SubScript].include? @current_block.text[-2].class and @current_block.text.last.empty?
    @current_block << s
  end

  def eqn_bounds(parse_tree)
    bound = EqnBlock.new(font: @current_block.text.last.font.dup, style: @current_block.text.last.style.dup)
    bound.style.css[:display] = 'block'
    bound.style.css[:position] = 'relative'
    bound.style.css[:margin] = '0 0.1em'
    unescape "\\s-3", output: bound
    gen_eqn [parse_tree.shift], output: bound
    unescape "\\s+3", output: bound

    # move ourselves into a new block containing all bounds, unless we've already done it
    unless @current_block.text[-2]&.style&.css&.[](:whitespace)
      container = EqnBlock.new(font: @current_block.text.last.font.dup, style: @current_block.text.last.style.dup)
      container.style.css[:text_align] = 'center'
      container.style.css[:whitespace] = 'nowrap'
      container.style.css[:vertical_align] = '-0.95em'
      container.style.css[:height] = '1em'
      container.text = @current_block.text.slice!(-2..-1)
      @current_block << container
    else
      container = @current_block.text[-2]
    end

    __callee__ == :eqn_from ? container << bound : container.text.insert(0, bound)
  end

  %w[cos sin tan cosh sinh tanh arc acos asin atan
     exp ln log max min Re Im and det for if].each do |word|
    alias_method "eqn_#{word}".intern, :eqn_word
  end

  %w[sub sup].each do |word|
    alias_method "eqn_#{word}".intern, :eqn_script
  end

  %w[from to].each do |word|
    alias_method "eqn_#{word}".intern, :eqn_bounds
  end

end
