# html.rb
# ---------------
#    html classes
# ---------------
#

class Block

  attr_accessor :type, :text, :style

  def initialize(type)
    @type = type
    @text = Array.new
    @style = Hash.new
  end

  def to_ml
    str = String.new
    @text.each do |span|
      str << span.to_ml
    end

    case @type
    when :p then "<p>#{str}</p>\n"
    end
  end

  def to_s
    str = String.new
    @text.each do |span|
      str << span.to_s
    end
    str
  end

end

class Span

  attr_accessor :type, :text, :style

  def initialize(type)
    @type = type
    @text = Array.new
    @style = Hash.new
  end

  def to_ml
    str = String.new
    @text.each do |span|
      str << span.to_ml
    end

    tag = case @type
          when :r
            if @style.empty? then "span" else "" end
          when :i then "em"
          when :b then "strong"
          end

    styled_tag = "#{tag}"	# need a copy of tag, not a reference to it
    styled_tag << ' style="' + @style.to_ml + '"' unless @style.empty?

    if styled_tag.empty? then str else str.sub(/(.+?)(\s*)$/, "<#{styled_tag}>\\1</#{tag}>\\2") end

  end

  def to_s
    str = String.new
    @text.each do |span|
      str << span.to_s
    end
    str
  end

end

class String
  def to_ml
    self
  end
end

class Hash
  def to_ml
    style = String.new
    self.each do |k,v|
      case k
      when "baseline" then style << "baseline-shift:#{v};"
      end
    end

    style
  end
end
