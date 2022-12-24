# Created by R. Stricklin <bear@typewritten.org> on 10/11/17.
# Copyright 2017 Typewritten Software. All rights reserved.
#
#
# Font class
#
# TODO delegate text color to this class?

require_relative '../modules/immutable.rb'
require_relative 'styles/font.rb'

class Font
  include Immutable

  @@defaultsize = 12

  attr_reader :size

  def initialize(arg = Hash.new)
    @size   = (arg[:size] or @@defaultsize)
    @warned = false
  end

  def tag ; 'span' ; end
  def css_class ; 'u' ; end
  def css_style ; nil ; end

  def face
    self.class.name[6..-1] # strip off the 'Font::' part, to match what goes in @state[:fonts]
  end

  def style
    {
      :tag => get_tag,
      :class => css_class,
      :styles => get_styles
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

  alias family face
  #alias size=  immutable_setter # REVIEW I think we're no longer trying to apply a size directly

  def self.defaultsize
    @@defaultsize
  end

  private

  def get_tag
    tag || ((css_class or get_styles) ? 'span' : nil)
  end

  def get_styles
    styles = css_style || ''
    styles << (@size == @@defaultsize ? '' : "font-size:#{@size}pt;")
    styles.empty? ? nil : styles
  end

end
