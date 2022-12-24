module Eqn

  def eqn_gfont(f)
    warn "eqn requests gfont #{f}"
    @state[:eqn_gfont] = f
  end

  def eqn_gsize(s)
    warn "eqn requests gsize #{s}"
    @state[:eqn_gsize] = s.to_i + 2 # troff default size 10 vs. ours 12
  end

  def eqn_size(parse_tree)
    req_ps "#{parse_tree.shift.to_i + 2}"
  end

  def eqn_roman(parse_tree)
    eqn_font ['1', [parse_tree.shift]]
  end

  def eqn_italic(parse_tree)
    eqn_font ['2', [parse_tree.shift]]
  end

  def eqn_bold(parse_tree)
    eqn_font ['3', [parse_tree.shift]]
  end

  def eqn_font(parse_tree)
    req_ft parse_tree.shift
    gen_eqn [parse_tree.shift]
    req_ft @state[:eqn_gfont]
  end

  # bar and under are made the right length for the entire construct

  def eqn_bar(parse_tree)
    bar = EqnBlock.new(font: @current_block.text.last.font.dup, style: @current_block.text.last.style.dup)
    #bar.style.css[:border_top] = '1px solid'
    bar.style.css[:text_decoration] = 'overline'
    gen_eqn [parse_tree.shift], output: bar
    @current_block << bar
  end

  def eqn_under(parse_tree)
    bar = EqnBlock.new(font: @current_block.text.last.font.dup, style: @current_block.text.last.style.dup)
    #bar.style.css[:border_top] = '1px solid'
    bar.style.css[:text_decoration] = 'underline'
    gen_eqn [parse_tree.shift], output: bar
    @current_block << bar
  end

end
