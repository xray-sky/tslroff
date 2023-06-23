=begin
module Locator
  def locate(loc: '.sw at 0,0')
    (corner, pos) = loc.split(' at ')
    position = Point.new pos
    case corner
    when '.nw' then position.y = position.y + @height
    when '.se' then position.x = position.x + @widhth
    when '.ne'
      position.y = position.y + @height
      position.x = position.x + @width
    end
    position
  end
end

class Pic

  def initialize(pos: Point.new, ht: 0.5, wid: 0.75, label: '', visible: true)
    @position = pos
    @height = ht
    @width = wid
    @visible = visible
  end

  def visible? ; @visible ; end

  def c ; @position ; end
  def n ; (@height/2.0) + @position ; end
  def e ; (@width/2.0) + @position ; end
  def s ; (@height/-2.0) + @position ; end
  def w ; (@width/-2.0) + @position ; end
  def ne ; corner + @position ; end
  def nw ; corner * Point.new("-1,1") + @position ; end
  def se ; corner * Point.new("1,-1") + @position ; end
  def sw ; corner * Point.new("-1,-1") + @position ; end

  def with(name, at: Point.new)
    align_on = send name
    centeroffset = center - align_on
    @position = at + centeroffset
  end

  class Point
    attr_accessor :x, :y
    def initialize(pos: '0,0')
      (@x, @y) = pos.split(',').map(&:strip)
    end
    def -(pos)
      Point.new("#{@x - pos.x},#{@y - pos.y}")
    end
    def +(pos)
      Point.new("#{@x + pos.x},#{@y + pos.y}")
    end
    def *(pos) # feeble
      Point.new "#{@x * pos.x},#{@y * pos.y}"
    end
    def to_a
      [@x, @y]
    end
    def to_s
      "#{@x},#{@y}"
    end
    def to_svg(n = '')
      %(x#{n}="#{@x}" y#{n}="#{@y}")
    end
  end

  class Ellipse
    def to_svg
      # ...translate?
      visible? ? %(<ellipse transform="translate(#{(@position.x)+(0.5*@width)},#{@position.y})" rx="#{@width*0.5}" ry="#{@height*0.5}">) : ''
    end
    private
    def corner
      x = (@height * @width) / ((@height ** 2 + @width ** 2) ** 0.5)
      Point.new("#{x},#{x}")
    end
  end

  class Circle < Ellipse # not just a degenerate Ellipse; I need to be able to refer to e.g. "last circle"
    def initialize(pos: Point.new, rad: 0.25, visible: true)
      @position = pos
      @height = rad
      @width = @height
      @visible = visible
    end
  end

  # what is the point of an invisible box
  # the point is to have a name to refer to for positioning other objects
  class Box
    def to_svg
      visible? ? %(<rect #{@position.to_svg} width=#{@width} height=#{@height} />\n) : ''
    end
    private
    def corner
      Point.new("#{@width/2.0},#{@height/2.0}")
    end
  end

  class Arrowhead
    def initialize(line)
      @slope = line.slope
      @terminus = line.nodes.last
      @head = [ Point.new('0,0'), Point.new('-2.5,-10'), Point.new('2.5,-10') ]
    end
    def to_svg

    end
  end

  class Line
    attr_reader :nodes
    def initialize(arrow: nil, from: '0,0', to: '0,0')
      @nodes = [ Point.new from, Point.new to ]
      @arrow = arrow
    end
    def <<(to)
      @nodes << Point.new to
    end
    def slope
      (x1, y1) = @nodes.first.to_a
      (x2, y2) = @nodes.last.to_a
      return nil if x1 == x2 # vertical; no slope
      (y2 - y1).to_f / (x2 - x1)
    end
    def segments
      segs = []
      n = @nodes.each
      s = n.next
      loop do
        e = n.next
        segs < [s, e]
        break unless n.peek
        s = e
      end
      segs
    end
    def to_svg
      if @nodes.length == 2
        %(<line #{@nodes.first.to_svg('1')} #{@nodes.last.to_svg('2'))} />\n)
      else
        %(<polyline points="#{@nodes.map(&:to_s).join(' ')}" />)
      end
      case @arrow
      when nil then ''
      when '->'
        Arrowhead.new(self)
      end
    end
  end

end
=end
