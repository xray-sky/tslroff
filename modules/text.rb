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

    # Multiple inter-word space characters found in the input are retained. §4.1
    ent = text
    while ent.match(/  /)
      ent.sub!(/  /, '&nbsp; ')
    end 

    # troff treats ` and ' like typesetter's quotes (§2.1)
    # make sure < and > are printable while we're at it
    ent.gsub!(/(?:<|>|`+|'+)/) do |c|
      case c
      when '``' then '&ldquo;'
      when "''" then '&rdquo;'
      when '`'  then '&lsquo;'
      when "'"  then '&rsquo;'
      when '<'  then '&lt;'
      when '>'  then '&gt;'
      end
    end

    # translate some troff fill/adjust fluff
    ent.gsub!(/(?:&troff_\S+?;)/) do |e|
      case e
      when '&troff_br;'  then '<br />'
      when '&troff_nrs;' then %(<span class="nrs"></span>)
      when '&troff_hns;' then %(<span class="hns"></span>)
      end
    end

    # mark it up the rest of the way
    (tags + [ent] + (tags.reverse.map { |t| t.sub(/^</, '</').sub(/\s.*/, '>') })).join
  end

  alias concat <<
end
