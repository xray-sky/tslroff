# Created by R. Stricklin <bear@typewritten.org> on 09/05/17.
# Copyright 2017 Typewritten Software. All rights reserved.
#
#
# TaggedText class
# implements format-agnostic rich text
#

class ImmutableTagError < Exception
end

class TaggedText

  def initialize ( text = "" , tags = {} )
    @text = [text]
    @tags = tags
  end
  
  def << ( text )
    @text << text
  end

  def empty?
    self.untag.strip.empty?
  end
  
  def tagged?
    return false if @tags.keys.empty?
  end

  def to_s
    @text.map do |t|
      t.respond_to?(:tagged?) ? t.to_html : t
    end.join
  end
  
  def to_html
    return "" if self.empty?
    tags = @tags.map do |t,v|
      case t
        when :b         then "<strong>"
        when :i         then "<em>"
        when :shift     then "<span style=\"baseline-shift:#{v};\">"
        else            "<!! #{v} !!>"
      end
    end
    (tags + [self.to_s] + (tags.reverse.map do |t| t.sub(/^</,"</").sub(/\s.*/,">") ; end ) ).join
  end

  def untag
    @text.map do |t|
      t.respond_to?(:tagged?) ? t.untag : t
    end.join
  end

  def tag ( tag )
    tag.each do |t,v|
      unless @tags.has_key?(t) and @tags[t] == v
        if text.empty?
          @tags[t] = v
        else
          raise ImmutableTagError
        end
      end
    end
  end

end