class Troff
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
              end
    col = Column.new(justify: justify, font: @current_block.terminal_font.dup, style: @current_block.terminal_text_style.dup)
    col.style.css[:line_height] = '1.5em' if method.end_with?('col') # matrix
    gen_eqn [parse_tree.shift], output: col
    @current_block << col
  end

  %w[lpile cpile rpile lcol ccol rcol].each do |word|
    alias_method "eqn_#{word}".intern, :eqn_pile
  end

  def eqn_bracket(parse_tree)
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
    height = begin
               to_em(to_u(Troff.webdriver.find_element(id: 'selenium').size.height.tap { |n| warn "selenium measured bracket inside height #{n.inspect}px" }.to_s, default_unit: 'px'))
             rescue Selenium::WebDriver::Error::NoSuchElementError => e
               warn e
              'NaN' # REVIEW side effects - returning nil - but what string makes sense?
             end

    # minimum number of bracket pieces needed - next higher integer value
    pieces = (height + 1).to_i

    unless lbrk.empty?
      if height <= 1
        unescape "\\f1#{lbrk}\\fP\\0"
      else
        extended = case lbrk
                   when '('  # top, bottom
                     [ '&#9115;' ] + Array.new([0, pieces - 2].max, '&#9116;') + [ '&#9117;' ]
                   when '['  # top, bottom
                     [ '&#9121;' ] + Array.new([0, pieces - 2].max, '&#9122;') + [ '&#9123;' ]
                   when '{'  # top, middle, bottom, a top and bottom extension
                     bvs = Array.new([0, pieces - 3].max, '&#9130;')
                     [ '&#9127;' ] + bvs + [ '&#9128;' ] + bvs + [ '&#9129;' ]
                   when '\\(lc', 'ceiling'
                     [ '&#9121;' ] + Array.new([0, pieces - 1].max, '&#9122;')
                   else # DANGER REVIEW TODO
                     [ lbrk ]
                   end
      end

      if extended.count == 1 # punt, dunno how to make a tall one
        warn "eqn bracket trying to make large #{lbrk.inspect}? HOW"
        unescape "\\f1#{lbrk}\\fP\\0"
      else
        lbracket = Bracket.new(line_height: height/pieces,
                                     style: @current_block.terminal_text_style.dup,
                                      font: Font::R.new(size: @register['.s'].value))
        lbracket.style.css[:text_align] = 'right' # REVIEW may not be necessary
        extended.each do |c|
          lbracket << Text.new(font: lbracket.terminal_font.dup, style: lbracket.terminal_text_style.dup)
          unescape c, output: lbracket
        end
        @current_block << lbracket
      end
    end # lbrk

    @current_block << blk

    return unless rbrk

    if height <= 1
      unescape "\\0\\f1#{rbrk}\\fP"
    else
      extended = case rbrk
                 when ')'  # top, bottom
                   [ '&#9118;' ] + Array.new([0, pieces - 2].max, '&#9119;') + [ '&#9120;' ]
                 when ']'  # top, bottom
                   [ '&#9124;' ] + Array.new([0, pieces - 2].max, '&#9125;') + [ '&#9126;' ]
                 when '}'  # top, middle, bottom, a top and bottom extension
                   bvs = Array.new([0, pieces - 3].max, '&#9130;')
                   [ '&#9131;' ] + bvs + [ '&#9132;' ] + bvs + [ '&#9133;' ]
                 when '\\(rc', 'ceiling'
                   [ '&#9124;' ] + Array.new([0, pieces - 1].max, '&#9125;')
                 else # DANGER REVIEW TODO
                   [ rbrk ]
                 end
    end

    if extended.count == 1 # punt, dunno how to make a tall one
      warn "eqn bracket trying to make large #{rbrk.inspect}? HOW"
      unescape "\\0\\f1#{rbrk}\\fP"
    else
      rbracket = Bracket.new(line_height: height/pieces,
                                   style: @current_block.terminal_text_style.dup,
                                    font: Font::R.new(size: @register['.s'].value))
      rbracket.style.css[:text_align] = 'left' # REVIEW may not be necessary
      extended.each do |c|
        rbracket << Text.new(font: rbracket.terminal_font.dup, style: rbracket.terminal_text_style.dup)
        unescape c, output: rbracket
      end
      @current_block << rbracket
    end # rbrk
  end

end
end
