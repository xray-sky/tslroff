class Pic
  def initialize()
    @objects = []
    @named_objects = {}
  end

  def to_html
    %(<svg xmlns="http://www.w3.org/2000/svg">
        <defs>
          #{@named_objects.collect(&:to_def).join}
        </defs>
        #{@objects.collect(&:to_svg).join}
      </svg>
     )
  end
end

class Point
  attr_accessor :x, :y
  def initialize(pos: '0,0')
    (@x, @y) = pos.split(',').collect(&:strip)
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

  def to_svg(n: '') # utility?
    %(x#{n}="#{@x}" y#{n}="#{@y}")
  end

  private

  def translate(pos)
    @x.send __callee__, pos.x
    @y.send __callee__, pos.y
  end

  %w( += -= ).each do |m|
    class_eval("alias :#{m} :translate")
    public m.to_sym
  end
end


class PicElement
  def initialize(origin: Point.new, height: 0, width: 0, visible: true)
    @visible = visible
    @origin = origin
    @height = height
    @width = width
  end

  def move(coord) ; @origin = coord ; end
  def translate(coord) ; @origin += coord ; end
  def visible? ; @visible ; end
end

class Box < PicElement
  def to_svg
    return '' unless visible?
    %(<rect #{@origin.to_svg} height="#{@height}" width="#{@width}" />)
  end
end

class Line < PicElement
  def initialize(head: Point.new, tail: Point.new, arrowhead: nil)
    @head = head
    @tail = tail
    @arrowhead = arrowhead
  end

  def to_svg
    return '' unless visible?
    %(<line #{@head.to_svg(1)} #{@tail.to_svg(2)} stroke="black" />)
  end
end
