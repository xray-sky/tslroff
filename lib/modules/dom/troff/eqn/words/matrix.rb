module Eqn

  def eqn_above(parse_tree)
    @current_block << LineBreak.new(font: @current_block.terminal_font.dup, style: @current_block.terminal_text_style.dup)
    gen_eqn [parse_tree.shift]
  end

  def eqn_matrix(parse_tree)
    # TODO matrix forces rows to line up. not guaranteed with pile.
    warn "eqn setting matrix #{parse_tree.inspect} - check row alignment"
    gen_eqn [parse_tree.shift]
  end

  def eqn_pile(parse_tree)
    method = __callee__.to_s[4..-1]
    justify = case method[0]
              when 'r' then 'right'
              when 'l' then 'left'
              when 'c' then 'center'
              else nil
              end
    col = Column.new(justify: justify, font: @current_block.terminal_font.dup, style: @current_block.terminal_text_style.dup)
    col.style.css[:line_height] = '1.5em' if method.end_with?('col') # matrix
    gen_eqn [parse_tree.shift], output: col
    @current_block << col
  end

  %w[cpile rpile lcol ccol rcol].each do |word|
    alias_method "eqn_#{word}".intern, :eqn_pile
  end

  def eqn_bracket(parse_tree)
    # TODO make these into the "appropriate sized" brackets, with a little extra padding space inside maybe
    lbrk = case x = parse_tree.shift
           when 'c' then "\\(lc"
           when 'f' then "\\(lf"
           else x
           end
    rbrk = case x = parse_tree.shift
           when 'c' then "\\(rc"
           when 'f' then "\\(rf"
           else x
           end

    blk = EqnBlock.new(font: @current_block.terminal_font.dup, style: @current_block.terminal_text_style.dup)
    blk.style.css[:vertical_align] = 'middle'
    gen_eqn [parse_tree.shift], output: blk

    # how tall is that guy
    selenium = Block::Selenium.new(text: blk)
    selenium.style.css[:display] = 'block'
    Troff.webdriver.get selenium.to_html
    begin
      height = to_em(to_u(Troff.webdriver.find_element(id: 'selenium').size.height.tap{|n|warn "selenium measured height #{n.inspect}px"}.to_s, default_unit: 'px'))
    rescue Selenium::WebDriver::Error::NoSuchElementError => e
      warn e
      'NaN' # REVIEW: side effects - returning nil - but what string makes sense?
    end

    unless lbrk.empty?
      if height <= 1
        unescape "\\f1#{lbrk}\\fP\\0"
      else
        scaleheight = height * 0.75 # maximum line spacing for non-gapped bracket
        extended = case lbrk        # how many \(bv will we need; add 1 so to_i rounds down to correct int
                   when '('  # top, bottom
                     bvs = (((scaleheight - 1.5) * 0.75) + 1).to_i
                     [ '\\(lt' ] + Array.new(bvs, '\\(bv') + [ '\\(lb' ]
                   when '['  # top, bottom
                     bvs = (((scaleheight - 1.5) * 0.75) + 1).to_i
                     [ '\\(lc' ] + Array.new(bvs, '\\(bv') + [ '\\(lf' ]
                   when '{'  # top, middle, bottom, a top and bottom extension
                     bvs = (((scaleheight - 2.25) * 0.375) + 1).to_i
                     [ '\\(lt' ] + Array.new((bvs+1)/2, '\\(bv') + [ '\\(lk' ] + Array.new((bvs+1)/2, '\\(bv') + [ '\\(lb' ]
                   when '\\(lc', '\\(lf' # just top
                     bvs = (((scaleheight - 0.75) * 0.75) + 1).to_i
                     [ lbrk ] + Array.new(bvs, '\\(bv')
                   else  # DANGER REVIEW TODO
                     [ lbrk ]
                   end
      end

      if extended.count == 1 # punt, dunno how to make a tall one
        warn "eqn bracket trying to make large #{lbrk.inspect}? HOW"
        unescape "\\f1#{lbrk}\\fP\\0"
      else
        extheight = extended.count * 0.75
        lineheight = 0.75 #- ((extheight - height) / extheight) # the extent to which we are too tall
        lbracket = Bracket.new(line_height: lineheight,
                                     style: @current_block.terminal_text_style.dup,
                                      font: Font::R.new(size: @register['.s'].value))
        lbracket.style.css[:text_align] = 'right'
        extended.each do |c|
          lbracket << Text.new(font: lbracket.terminal_font.dup, style: lbracket.terminal_text_style.dup)
          unescape c, output: lbracket
        end
        @current_block << lbracket
      end

    end # lbrk

    @current_block << blk

    if rbrk
      if height <= 1
        unescape "\\0\\f1#{rbrk}\\fP"
      else
        # we can use all the calculations we did for the left bracket,
        # just change the escapes. fortunately all the left/right handed
        # characters differ only by \(l? vs. \(r?
        extended = extended.map { |c| c.sub(/\(l/, '(r') }
      end

      if extended.count == 1 # punt, dunno how to make a tall one
        warn "eqn bracket trying to make large #{rbrk.inspect}? HOW"
        unescape "\\0\\f1#{rbrk}\\fP"
      else
        rbracket = Bracket.new(line_height: lineheight,
                                     style: @current_block.terminal_text_style.dup,
                                      font: Font::R.new(size: @register['.s'].value))
        rbracket.style.css[:text_align] = 'left'
        extended.each do |c|
          rbracket << Text.new(font: rbracket.terminal_font.dup, style: rbracket.terminal_text_style.dup)
          unescape c, output: rbracket
        end
        @current_block << rbracket
      end

    end # lbrk
  end

end
