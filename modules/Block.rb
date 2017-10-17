# Created by R. Stricklin <bear@typewritten.org> on 10/11/17.
# Copyright 2017 Typewritten Software. All rights reserved.
#
#
# Block class
#

require "modules/Immutable.rb"
require "modules/Style.rb"
require "modules/Text.rb"

class Block
  include Immutable

  attr_reader   :text, :type
  attr_accessor :style

  def initialize ( arg = Hash.new )
    @control   = :Block
    self.style = (arg[:style] or Style.new(:control => @control))
    self.text  = (arg[:text]  or Text.new)
    self.type  = (arg[:type]  or :p)
  end

  def << ( t )
    case t.class.name
      when "String" then @text.last << t
      when "Text"   then @text << t
    end
    self.freeze if t.length > 0
  end

  def freeze
    self.frozen? or self.style.freeze
  end

  def frozen?
    self.style.frozen?
  end

  def text= ( t )
    @text = [t]
    self.freeze if t.length > 0
  end

  def to_html
    t=self.text.map { |t| t.to_html }.join(" ")
    case self.type
      when :comment then "<!--#{t} -->"
      when :sh then "<h2>#{t}</h2>"
      when :th then "<h1>#{t}</h1>"
      when :tp then "<dl><dt>#{self.style.tag}</dt><dd>#{t}</dd></dl>"	# this needs more work to leave <dl> open
      when :p  then "<p>#{t}</p>" unless self.text.empty?
      else          "<p style=\"color:gray;\">BLOCK(#{self.type})<br>#{t}</p>"
    end
  end

  alias_method :concat, :<<
  alias_method :type=,  :immutable_setter

end

