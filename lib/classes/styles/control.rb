# TODO ugh avoid
class String
  alias_method :to_html, :to_s
end

# TODO
# come up with a strict definition for the meanings of empty? and length

class RoffControl < Text
  def initialize(arg = {})
    # REVIEW the order of this might make it hard
    # to get the intended result in a subclass
    arg[:text] ||= ''
    super(arg)
    immutable!
  end
  def to_html ; warn 'unimplemented control' ; '' ; end
  def inspect ; "  <===== undifferentiated control =====> " ; end
  alias text= immutable_setter
end

class Continuation < RoffControl
  def inspect ; "<<== continuation #{@text}==>> " ; end
  def to_html ; '' ; end
end

# may need to subclass this further if we end up needing
# other kinds of breaks? for Block.<< to do the right thing
class LineBreak < RoffControl
  def initialize(arg = {})
    arg[:text] = "\n"
    super(arg)
  end
  def to_html ; '<br />' ; end
  def empty ; false ; end
  def inspect ; "<===== line break =====> " ; end
  def stop ; 0 ; end # for calculation of tabs
end

# non-outputting, non-empty placeholder
# used by .TP for making sure a tab outputs
# REVIEW may be unnecessary after objectification happens
class PlaceHolder < RoffControl
  def to_html ; '' ; end
  def length ; 1 ; end
  def empty ; false ; end
  def inspect ; '<<== placeholder ==>> ' ; end

end

#class Continuation < RoffControl
#  def inspect ; '<<== continuation ==>>' ; end
#end

# REVIEW hopefully I can do away with this hack
# after having objectified
class EndSpan < RoffControl
  def to_html ; '</span>' ; end
  def inspect ; "<===== end span =====> " ; end
end

# these are not actually used; the numeric alignments are done
# at the Block level
#
#class TableNAlignRight < RoffControl
#  def initialize(str) ; @str = str ; end
#  def to_html ; '<span class="nalign">#{str.to_html}</span>' ; end
#  def inspect ; "ign==>>" ; end
#end
#
#class TableNAlignLeft < RoffControl
#  def initialize(str) ; @str = str ; end
#  def to_html ; '<span class="nalign" style="text-align:right">#{@str.to_html}</span>' ; end
#  def inspect ; "<<==al" ; end
#end

class BellLogo < RoffControl
  def to_s ; '<<== Bell logo ==>> ' ; end
  def to_html ; %(<img src="/Manual/bell_logo.svg" style="height:1em;vertical-align:-0.2em;" />) ; end
  def empty? ; false ; end
  def length ; 1 ; end
  alias_method :inspect, :to_s
end

class NarrowSpace < RoffControl
  def initialize(arg = {})
    arg[:text] = ' '
    super(arg)
  end
  def to_html ; '<span class="nrs"></span>' ; end
  def inspect ; '<<== narrow space ==>> ' ; end
end

class HalfNarrowSpace < RoffControl
  def initialize(arg = {})
    arg[:text] = ' '
    super(arg)
  end
  def to_html ; '<span class="hns"></span>' ; end
  def inspect ; '<<== narrow space ==>> ' ; end
end

class HorizontalSpace < RoffControl
  def initialize(arg = {})
    arg[:text] = ' '
    super(arg)
    @width = arg[:width]
  end
  def to_html ; %(<span class="tab" style="width:#{@width}em;"></span>) ; end
  def inspect ; "<<== #{@width} horizontal space ==>> " ; end
end

class VerticalSpace < RoffControl
  def initialize(arg = {})
    super(arg)
    @height = arg[:height]
  end
  def to_html ; %(<span class="vs" style="height:#{@height}em;"></span>) ; end
  def empty ; false ; end
  def inspect ; "<<== #{@height} vertical space ==>> " ; end
end

class ExtraLineSpace < RoffControl
  def initialize(arg = {})
    super(arg)
    @height = arg[:height]
  end
  # REVIEW do I need to do something to keep this from going invisible? (inserted from \x)
  def to_html ; %(<span style="padding_#{@height > 0 ? 'top' : 'bottom'}:#{@height}em;"></span>) ; end
  def empty ; true ; end
  def inspect ; "<<== #{@height} extra line space ==>> " ; end
end

class Overstrike < RoffControl
  def initialize(arg = {})
    @chars = arg[:chars] || ['']
    arg[:text] = @chars[0]
    super(arg)
  end
  def to_html
    %(<span role="overstrike" class="clash"#{@style}>#{@chars.collect(&:to_html).join('<br />')}</span>)
  end
  def inspect ; "<<== overstrike: #{@chars.inspect} ==>> " ; end
end

class NonSpacing < RoffControl
  def initialize(arg = {})
    super(arg)
    style.css[:display] = 'inline-block'
    style.css[:width] = 0
    style.css[:color] = 'green'
  end
  def to_html
    %(<span role="non-spacing-character" #{@style}>#{@text.collect(&:to_html).join}</span>)
  end
  def inspect ; "<<== non-spacing character: #{@text.inspect} ==>> " ; end
end

class Rule < RoffControl
  def initialize(arg = {})
    arg[:text] = '___'
    super(arg)
    @width = arg[:width] || 0
  end
  def to_html ; %(<span style="width:#{@width}em;display:inline-block;border-top:1px solid black;"></span>) ; end
  def inspect ; "<<== #{@width} horizontal rule ==>> " ; end
end

class Unsupported < RoffControl
  def initialize(thing) ; @thing = thing ; end
  def to_s ; "<<== unsupported: #{thing.inspect} ==>> " ; end
  def to_html ; %(<span class="u">#{thing.inspect}</span>) ; end
  alias_method :inspect, :to_s
end
