# Created by R. Stricklin <bear@typewritten.org> on 10/11/17.
# Copyright 2017 Typewritten Software. All rights reserved.
#
#
# Font class
#
# TODO delegate text color to this class?

require_relative '../modules/immutable'
require_relative 'styles/font'

class Font
  include Immutable

  Defaultsize = 12

  attr_reader :size

  def initialize(size: Defaultsize)
    @size = size
  end

  def tag ; 'span' ; end
  def css_class ; 'u' ; end
  def css_style ; nil ; end

  def face
    self.class.name[6..-1] # strip off the 'Font::' part, to match what goes in @state[:fonts]
  end

  def style
    {
      tag: tag,
      class: css_class,
      styles: css_styles
    }
  end

  def inspect
    "{{ font: #{face}	size: #{@size.inspect} }}"
  end

  # comparison methods necessary for immutable setter
  def ==(other)
    style == other.style
  end

  def !=(other)
    style != other.style
  end

  def self.defaultsize
    Defaultsize
  end

  alias_method :family, :face

  private

  def css_styles
    styles = "#{css_style}#{@size == Defaultsize ? '' : "font-size:#{@size}pt;"}"
    styles.empty? ? nil : styles
  end

end
