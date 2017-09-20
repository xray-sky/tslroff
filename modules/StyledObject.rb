# Created by R. Stricklin <bear@typewritten.org> on 09/06/17.
# Copyright 2017 Typewritten Software. All rights reserved.
#
#
# StyledObject class
# implements format-agnostic block text
#
#   *** probably this isn't a great name
#

class StyledObject

  attr_reader :text, :style
  
  def initialize ( text = "" , style = :p, params = {} )
    @text = TaggedText.new(text)
    @style = style
    @params = params
  end
  
  def << ( text )
    @text << text
  end

  def append ( text )
    @text << text
  end

  def style! ( style )
    unless @style == style
      if text.empty?
        @style = style
      else
        raise ImmutableStyleError 
      end
    end
  end

end

class ImmutableStyleError < Exception
end