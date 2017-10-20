# Created by R. Stricklin <bear@typewritten.org> on 10/11/17.
# Copyright 2017 Typewritten Software. All rights reserved.
#
#
# Text class
#

require "forwardable"
require "modules/Immutable.rb"
require "modules/Font.rb"
require "modules/Style.rb"

class Text
  include Immutable
  extend Forwardable
  def_delegators :@text, :length

  attr_reader   :text
  attr_accessor :font, :style

  def initialize ( arg = Hash.new )
    @control   = :Text
    self.font  = (arg[:font]  or Font.new(:control => @control))
    self.style = (arg[:style] or Style.new(:control => @control))
    self.text  = (arg[:text]  or String.new)
  end

  def << ( t )
    @text << t
    self.freeze if t.length > 0
  end

  def freeze
    unless self.frozen?
      self.font.freeze
      self.style.freeze
    end
  end

  def frozen?
    self.font.frozen? or self.style.frozen?
  end

  def text= ( t )
    @text = t
    self.freeze if t.length > 0
  end

  def to_html
    return "" if self.length == 0
    tags = Array.new
    tags << case self.font.face
      when :bold    then "<strong>"
      when :italic  then "<em>"
      when :regular then ""
    end
    if self.style.keys.any?
      tags += self.style.collect do |t,v|
        case t
          when :shift       then "<span style=\"baseline-shift:#{v};\">"
          when :unsupported then "<span style=\"color:red;\">Unsupported tag: #{v} =&gt; "
          else                   "<span style=\"color:white;background:red;\">WTF? #{t}: #{v} =&gt; "
        end
      end
    end
    (tags + [self.text] + (tags.reverse.map do |t| t.sub(/^</,"</").sub(/\s.*/,">") ; end ) ).join
  end

  alias_method :concat, :<<

end

