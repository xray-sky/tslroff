class EqnBlock < Block
  def initialize(arg = {})
    arg[:type] = :eqn
    super(arg)
    self.font = arg[:font]
    # TODO move this crap to css
    #      get rid of block override in Fraction
    #      add nowrap
    style.css[:display] = 'inline-block'
    style.css[:text_indent] = '0'
    style.css[:color] = 'steelblue'
  end
  def font ; @text.last.font ; end
  def font=(arg) ; @text.last.font = arg ; end
  def to_html ; %(<span#{@style}>#{@text.collect(&:to_html).join}</span>) ; end
end

class Column < EqnBlock
  def initialize(arg = {})
    arg[:type] = :eqn_column
    super(arg)
    style.css[:text_align] = arg[:justify] if arg[:justify]
  end
  def to_html ; %(<span class="eqn-column"#{style}>#{@text.collect(&:to_html).join}</span>) ; end
end

class ExtendedRadical < EqnBlock
  def initialize(arg = {})
    arg[:type] = :extended_radical
    super(arg)
  end
  def to_html ; %(&radic;<span class="eqn-radical-xtnd">#{@text.collect(&:to_html).join}</span>) ; end
end

class Fraction < EqnBlock
  def initialize(arg = {})
    arg[:numerator] ||= Numerator.new
    arg[:denominator] ||= Denominator.new
    arg[:text] = [ arg[:numerator], FractionRule.new, arg[:denominator] ]
    super(arg)
    numerator.style.css.delete :display # don't let EqnBlock's local style override the css
    denominator.style.css.delete :display # don't let EqnBlock's local style override the css
    immutable!
  end
  def numerator ; @text[0] ; end
  def numerator=(arg) ; @text[0] = arg ; end
  def denominator ; @text[2] ; end
  def denominator=(arg) ; @text[2] = arg ; end
  def to_s ; text.collect(&:to_s).join ; end
  def to_html ; %(<span class="eqn-fraction"#{style}>#{@text.collect(&:to_html).join}</span>) ; end
end

class Denominator < EqnBlock
  def initialize(arg = {})
    arg[:type] = :denominator
    super(arg)
  end
  def to_html ; %(<span class="eqn-denominator"#{style}>#{@text.collect(&:to_html).join}</span>) ; end
end

class Numerator < EqnBlock
  def to_html ; %(<span class="eqn-numerator"#{style}>#{@text.collect(&:to_html).join}</span>) ; end
end

class FractionRule < RoffControl
  def to_s ; ' / ' ; end
  def to_html ; %(<span class="eqn-fraction-rule"> over </span>) ; end
  def inspect ; "<===== eqn fraction rule =====>\n" ; end
end

class SubScript < EqnBlock
  def initialize(arg = {})
    arg[:type] = :eqn_sscript
    super(arg)
  end
  def to_html ; %(<span class="eqn-subscript"#{style}>#{@text.collect(&:to_html).join}</span>) ; end
end

class SuperScript < EqnBlock
  def initialize(arg = {})
    arg[:type] = :eqn_sscript
    super(arg)
  end
  def to_html ; %(<span class="eqn-superscript"#{style}>#{@text.collect(&:to_html).join}</span>) ; end
end

class Bracket < EqnBlock
  def initialize(arg = {})
    super(arg)
    arg[:line_height] ||= 0.95
    @style.css[:display] = 'block'
    @style.css[:line_height] = arg[:line_height]
  end
  # REVIEW does the vertical align need adjusting for different size brackets?
  # I don't know why the heck vertical-align:middle doesn't work, except for all
  # the empty space calculated above the top bracket char. maybe it depends on the bracket chars?
  #
  # Somehow the top of the bracket starts too low.
  # it looks like we need to adjust -0.33em per bracket char?
  # REVIEW this is ridiculous weird
  def to_html
    offset = (@text.count - 1) / 3.0
    %(<span role="eqn-bracket" style="display:inline-block;vertical-align:-#{offset}em;"><span#{style}>#{@text.collect(&:to_html).join('<br />')}</span></span>)
  end
end
