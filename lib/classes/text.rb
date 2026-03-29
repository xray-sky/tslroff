# frozen_string_literal: true
#
# Created by R. Stricklin <bear@typewritten.org> on 10/11/17.
# Copyright 2017 Typewritten Software. All rights reserved.
#
#
# Text class
#

require 'forwardable'
require_relative 'font'
require_relative 'style'
require_relative '../modules/immutable'

class Text
  include Immutable

  attr_reader :text, :font, :style

  extend Forwardable
  def_delegators :@text, :length, :empty?, :to_s

  ENTITIES = {
    '``' => '&ldquo;',
    "''" => '&rdquo;',
    '`' => '&lsquo;',
    "'" => '&rsquo;',
    '<' => '&lt;',
    '>' => '&gt;'
  }.freeze

  def initialize(arg = {})
    @object_exception_class = Kernel.const_get(:ImmutableTextError)
    self.font  = (arg[:font]  or Font::R.new)
    self.style = (arg[:style] or Style.new({}, @object_exception_class))
    self.text  = (arg[:text]  or String.new)
  end

  # stop and width are overriden by anything providing tab structure
  def stop ; 0 ; end
  def width ; 0 ; end

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
    # TODO some or most of this should probably be made troff-specific (somehow)
    #return '<br />' if text.is_a?(LineBreak) # Break.empty? is true

    tags = []

    # tab separately, as it may encompass several Text objects
    # this relies on all other spans being closed tidily within a single Text object
    tab = @tab_width ? %(<span class="tab" style="width:#{@tab_width.round(3)};">) : ''

    if text.is_a?(RoffControl) or text.is_a?(Block::Inline)
      ent = text.to_html
    else
      return '' if length.zero?

      # Multiple inter-word space characters found in the input are retained. §4.1
      ent = text.dup
      while ent.match(/  /)
        ent.sub!(/  /, '&nbsp; ')
      end

      # troff treats ` and ' like typesetter's quotes (§2.1)
      # make sure < and > are printable while we're at it
      # TODO output complying &amp; without messing up any entities we already inserted
      ent.gsub!(/<|>|`+|'+/, ENTITIES)

      # font face & size - TODO this should be delegated to the font class
      f = font.style
      tags << %(<#{f[:tag]}#{f[:class] ? " class=#{f[:class]}" : ''}#{f[:styles] ? %( style="#{f[:styles]}") : ''}>) if f[:tag]

      if @style[:css].any?
        tags << %(<span#{@style}>) # TODO @styles.to_s incompatible with below probably
      end

      if @style.keys.any?
        tags += style.collect do |t, v| # TODO consolidate multiple styles??
          case t
          when :baseline         then %(<span style="position:relative;top:#{v.round(3)}em;line-height:0;">)
          when :horizontal_shift then %(<span style="position:relative;left:#{v.round(3)}em;">)
          when :word_spacing     then %(<span style="word-spacing:#{v.round(3)}em;">) # REVIEW this seems to give wider spaces than I'd expect - jot(1) [AOS-4.3]
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

  def tag(style)
    return '' unless style[:tag]
  end

  # override this from Immutable so that our subclasses
  # don't all try to dispatch their own unique exceptions
  #def object_exception_class
  #  Kernel.const_get("ImmutableTextError")
  #end

end
