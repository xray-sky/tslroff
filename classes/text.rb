# Created by R. Stricklin <bear@typewritten.org> on 10/11/17.
# Copyright 2017 Typewritten Software. All rights reserved.
#
#
# Text class
#

require 'forwardable'
require 'modules/immutable.rb'
require 'classes/font.rb'
require 'classes/style.rb'

class Text
  include Immutable
  extend Forwardable
  def_delegators :@text, :length, :empty?, :to_s

  attr_reader   :text
  attr_accessor :font, :style

  def initialize(arg = Hash.new)
    self.font  = (arg[:font]  or Font.new)
    self.style = (arg[:style] or Style.new({}, get_object_exception_class))
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

  def inspect
    #indent = text.is_a?(Array) ? 2 : 0
    #"#{" " * indent}font:  #{font.inspect} (#{text.class.name})\n#{" " * indent}style: " +
    "font:  [ #{font.inspect} ]\nstyle: " +
    style.inspect.each_line.collect { |l| l }.join("       ") + "\ntext:  " +
    text.inspect.each_line.collect { |l| l }.join("|         ") + "\n"
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
    ent.gsub!(/(?:&roffctl_\S+?;)/) do |e|
      case e
      when '&roffctl_br;'      then '<br />'
      when '&roffctl_nrs;'     then '<span class="nrs"></span>'
      when '&roffctl_hns;'     then '<span class="hns"></span>'
      when /&roffctl_sp:(.+);/ then %(<span style="display:inline-block;height:#{Regexp.last_match(1)};"></span>) # REVIEW: does this even work?
      when /&roffctl_.+;/      then '' # ignore any other roffctl code
      else warn "unimplemented #{e}"
      end
    end

    # mark it up the rest of the way
    (tags + [ent] + (tags.reverse.map { |t| t.sub(/^</, '</').sub(/\s.*/, '>') })).join
  end

  alias concat <<
end
