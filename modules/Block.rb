# Created by R. Stricklin <bear@typewritten.org> on 10/11/17.
# Copyright 2017 Typewritten Software. All rights reserved.
#
#
# Block class
#

require 'modules/Immutable.rb'
require 'modules/Style.rb'
require 'modules/Text.rb'

class Block
  include Immutable

  attr_reader   :text, :type
  attr_accessor :style

  def initialize(arg = Hash.new)
    @control   = :Block
    self.type  = (arg[:type]  or :p)
    self.style = (arg[:style] or Style.new(control: @control))
    self.text  = (arg[:text]  or Text.new)
  end

  def <<(t)
    case t.class.name
    when 'String' then @text.last << t
    when 'Text'   then @text << t
    end
    freeze unless t.empty?
  end

  def freeze
    frozen? or style.freeze
  end

  def frozen?
    style.frozen?
  end

  def text=(t)
    @text = [t]
    freeze unless t.empty?
  end

  def to_html             # TODO: this needs more work to leave <dl>, <!-->, etc. open for subsequent output
    t = text.map(&:to_html).join
    case type
    when :bare    then t
    when :comment then "<!--#{t} -->"
    when :sh      then "<h2>#{t}</h2>"
    when :th      then "<h1>#{t}</h1>"
    when :tp      then "<dl><dt>#{style.tag.to_html}</dt><dd>#{t}</dd></dl>"
    when :p       then "<p>#{t}</p>" unless text.empty?
    else          "<p style=\"color:gray;\">BLOCK(#{type})<br>#{t}</p>"
    end
  end

  alias concat <<
  alias type= immutable_setter

end
