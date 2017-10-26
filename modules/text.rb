# Created by R. Stricklin <bear@typewritten.org> on 10/11/17.
# Copyright 2017 Typewritten Software. All rights reserved.
#
#
# Text class
#

require 'forwardable'
require 'modules/immutable.rb'
require 'modules/font.rb'
require 'modules/style.rb'

class Text
  include Immutable
  extend Forwardable
  def_delegators :@text, :length, :empty?, :to_s

  attr_reader   :text
  attr_accessor :font, :style

  def initialize(arg = Hash.new)
    @control   = :Text
    self.font  = (arg[:font]  or Font.new(control: @control))
    self.style = (arg[:style] or Style.new(control: @control))
    self.text  = (arg[:text]  or String.new)
  end

  def <<(t)
    @text << t
    freeze unless t.empty?
  end

  def freeze
    return if frozen?
    font.freeze
    style.freeze
  end

  def frozen?
    font.frozen? or style.frozen?
  end

  def text=(t)
    @text = t
    freeze unless t.empty?
  end

  def to_html
    return '' if length.zero?
    tags = Array.new
    tags << case font.face
            when :bold    then '<strong>'
            when :italic  then '<em>'
            when :regular then ''
            end
    tags << %(<span style="font-size:#{font.size}pt;">) unless font.size.to_i == Font.defaultsize
    if @style.keys.any?
      tags += style.collect do |t, v|
        case t
        when :shift       then %(<span style="baseline-shift:#{v};">)
        when :unsupported then '<span style="color:red;">Unsupported request =&gt; '
        else                   %(<span style="color:white;background:red;">WTF? #{t}: #{v} =&gt; )
        end
      end
    end
    (tags + [text] + (tags.reverse.map { |t| t.sub(/^</, '</').sub(/\s.*/, '>') })).join
  end

  alias concat <<
end
