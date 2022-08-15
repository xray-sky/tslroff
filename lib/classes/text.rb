# Created by R. Stricklin <bear@typewritten.org> on 10/11/17.
# Copyright 2017 Typewritten Software. All rights reserved.
#
#
# Text class
#

require 'forwardable'
require_relative 'font.rb'
require_relative 'style.rb'
require_relative '../modules/immutable.rb'

class Text
  include Immutable
  extend Forwardable
  def_delegators :@text, :length, :empty?, :to_s#, :match, :match?, :sub, :sub!, :gsub, :gsub!

  attr_reader   :text, :font, :style

  def initialize(arg = Hash.new)
    self.font  = (arg[:font]  or Font::R.new)
    self.style = (arg[:style] or Style.new({}, get_object_exception_class))
    self.text  = (arg[:text]  or String.new)
  end

  # stop is overriden by anything providing tab structure
  def stop
    0
  end

  # width is overriden by anything providing tab structure
  def width
    0
  end

  def <<(t)
    @text << t
    immutable! unless t.empty?
  end

  def immutable!
    return if immutable?
    font.immutable!
    style.immutable!
  end

  def immutable?
    [ :@font, :@style ].find do |x|
      instance_variable_get(x).send(:immutable?) if instance_variable_defined?(x)
    end
  end

  def coerce(obj)
    [ Text.new(text: obj), self ]
  end

  def inspect
    <<~MSG

      font:  #{font.inspect}
      style: #{style.inspect.each_line.collect { |l| l }.join('       ')}
      text:  #{text.inspect.each_line.collect { |l| l }.join('|         ')}
    MSG
  end

  def text=(t)
    @text = t
    immutable! unless t.empty?
  end

  def to_html
    # TODO: some or most of this should probably be made troff-specific (somehow)
    #return '<br />' if text.is_a?(LineBreak) # Break.empty? is true

    tags = Array.new

    # tab separately, as it may encompass several Text objects
    # this relies on all other spans being closed tidily within a single Text object
    tab = @tab_width ? %(<span class="tab" style="width:#{@tab_width};">) : ''

    if text.is_a? RoffControl
      ent = text.to_html#.tap {|n| warn "Control to html #{self.inspect}" }
    else
      return '' if length.zero?

      # Multiple inter-word space characters found in the input are retained. §4.1
      ent = text.dup#.tap {|n| warn "non-control #{self.inspect}" }
      while ent.match(/  /)
        ent.sub!(/  /, '&nbsp; ')
      end

      # troff treats ` and ' like typesetter's quotes (§2.1)
      # make sure < and > are printable while we're at it
      ent.gsub!(/<|>|`+|'+/) do |c|
        case c
        when '``' then '&ldquo;'
        when "''" then '&rdquo;'
        when '`'  then '&lsquo;'
        when "'"  then '&rsquo;'
        when '<'  then '&lt;'
        when '>'  then '&gt;'
        end
      end

      # font face & size - TODO this should be delegated to the font class
      f = font.style
      tags << (f[:tag] ? "<#{f[:tag]}#{f[:class] ? " class=#{f[:class]}" : ''}#{f[:styles] ? %( style="#{f[:styles]}") : ''}>" : '')

      if @style[:css].any?
        tags << %(<span#{@style.to_s}>) # TODO @styles.to_s incompatible with below probably
      end

      if @style.keys.any?
        tags += style.collect do |t, v| # TODO consolidate multiple styles??
          case t
          when :baseline         then %(<span style="position:relative;top:#{v}em;line-height:0;">)
          when :horizontal_shift then %(<span style="position:relative;left:#{v}em;">)
          when :word_spacing     then %(<span style="word-spacing:#{v}em;">) # REVIEW this seems to give wider spaces than I'd expect - jot(1) [AOS-4.3]
          when :eqn              then %(<span style="color:steelblue;">)
          when :comment          then return %(<!--\n   #{@text}\n-->)
          else                        %(<span style="color:white;background:red;">WTF? #{t}: #{v} =&gt; ).tap { warn "text module WTF oops #{t.inspect} => #{v.inspect}" }
          end
        end
      end
    end

    # mark it up the rest of the way
    # REVIEW where does the tab span get closed?? it does, but..?
    #        is it with having inserted a &roffctl_endspan;? -- yes.
    tab + (tags + [ent] + (tags.reverse.map { |t| t.sub(/^</, '</').sub(/\s.*/, '>') })).join
  end

  alias concat <<
  alias font= immutable_setter
  alias style= immutable_setter

  private

  # override this from Immutable so that our subclasses
  # don't all try to dispatch their own unique exceptions
  def get_object_exception_class
    Kernel.const_get("ImmutableTextError")
  end

end
