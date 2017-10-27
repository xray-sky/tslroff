# Created by R. Stricklin <bear@typewritten.org> on 10/11/17.
# Copyright 2017 Typewritten Software. All rights reserved.
#
#
# Block class
#

require 'modules/immutable.rb'
require 'modules/style.rb'
require 'modules/text.rb'

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
    when 'Block'
      raise RuntimeError "appending non-bare block #{t.inspect}" unless t.type == :bare
      @text += t.text
    end
    freeze unless t.empty?
  end

  def empty?
    text.collect(&:to_s).join.empty?  # REVIEW: does this even make sense?
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
    t = text.collect(&:to_html).join
    case type
    when :bare    then t
    when :comment then %(<!--#{t} -->\n)
    when :th      then %(<div class="title"><h1>#{t}</h1></div><div class="body"><div class="man">\n)
    when :sh      then "<h2>#{t}</h2>\n"
    when :ss      then "<h3>#{t}</h3>\n"
    when :tp      then "<dl>\n <dt>#{style.tag.to_html}</dt>\n  <dd>#{t}</dd>\n</dl>\n" # FIXME: this crashes if 'tag' is unset.
    when :p       
      return if t.strip.empty?
      case style.section
      when 'SYNOPSIS' then %(<p class="synopsis">\n#{t}\n</p>\n)
      else                 "<p>\n#{t}\n</p>\n"
      end
    else          %(<p style="color:gray;">BLOCK(#{type})<br>#{t}</p>\n)
    end
  end

  alias concat <<
  alias type= immutable_setter
end
