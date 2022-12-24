# Created by R. Stricklin <bear@typewritten.org> on 10/11/17.
# Copyright 2017 Typewritten Software. All rights reserved.
#
#
# Block class
#

require 'forwardable'
require_relative 'style.rb'
require_relative 'text.rb'
require_relative '../modules/immutable.rb'

class Block
  include Immutable
  extend Forwardable

  attr_reader   :text, :type, :last_tab_position, :last_tab_stop
  attr_accessor :style
  def_delegators :@style, :immutable?, :immutable!

  def initialize(arg = Hash.new)
    self.style = (arg[:style] or Style.new({}, get_object_exception_class))
    #self.type  = (arg[:type]  or :p)
    self.text  = (arg[:text]  or Text.new)
    @last_tab_position = 0
    @last_tab_stop = 0
  end

  def output_indicator?
    @output_indicator
  end

  def reset_output_indicator
    @output_indicator = false
  end

  def empty?
    type == :comment or text.reject(&:empty?).none?
  end

  def text=(t)
    unless t.empty?
      @output_indicator = true
      immutable!
    end
    @text = t.is_a?(Array) ? t : [t]
  end

  def <<(t)
    case t
    when Tab # insert_tab does its own hold/append, since it changes @text.last
      @text << t
      @last_tab_position = t.stop
      @last_tab_stop = @text.count
    when RoffControl, EqnBlock # don't leave this as the last bit of text, or it'll eat appends to @text
      # we might be at the very start of Block when @text is still [] - TODO some smarter strategy
      # TODO also I think this broke Continuation?
      #hold = Text.new(font: @text.last&.font.dup || Font::R.new, style: @text.last&.style.dup || Style.new)
      @text << t
      if t.is_a? LineBreak or t.is_a? VerticalSpace
        @last_tab_position = 0
        @last_tab_stop = @text.count
      end
      @text << Text.new(font: @text.last&.font.dup || Font::R.new, style: @text.last&.style.dup || Style.new)
    when Text, Block::TableCell   then @text << t
    #when Text, Block::TableCell, Block::Pic   then @text << t
    when String
      if @text.last.text.respond_to?(:<<)
        @text.last << t
      else
        # REVIEW why was this case here? it duplicates LineBreak
        warn "we are in a degenerate part of the code - block.rb line 72"
        brk = Text.new(font: text.last.font.dup, style: text.last.style.dup)
        brk[:tab_stop] = 0
        brk.text = t
        @text << brk
      end
    when Block  # this is primarily meant for handling named strings, which may include typesetter escapes
      raise RuntimeError "appending non-bare block #{t.inspect}" unless t.type == :bare
      @text += t.text
      # don't leave the last text object open, or else you'll start writing into the named string definition.
      @text << Text.new(font: text.last.font.dup, style: text.last.style.dup)
    end
    (immutable! and @output_indicator = true) unless t.empty? # @output_indicator also manipulated in parse, for suppression after comment
  end

  def coerce(obj)
    [ Block.new(text: obj), self ]
  end

  def to_s
    text.collect(&:to_s).join
  end

  def to_selenium
    return %(data:text/html;charset=utf-8,<html><head><link rel="stylesheet" type="text/css" href="#{$CSS}"></link></head><body><div id="man"><span id="selenium">#{to_html}</span></div></body></html>)
  end

  def to_html             # TODO: this needs more work to e.g. leave <!-->, etc. open for subsequent output, but stay whitespace safe (don't introduce whitespace by inserting newlines, etc.)
    t = text.collect(&(type == :comment ? :to_s : :to_html)).join

    # insert related information references
    # REVIEW: am I going to need to make overrides to this regexp?
    # <br /> tags will be detected along with other styles we intend to include,
    # so we'll try to get the ones up front, so they can end up outside the <a>
    t.gsub!(%r{(?<break>(?:<br />)*)(?<text>(?:<[^<]+?>)*(?<entry>\S+?)(?:<[^<]+?>)*\((?:<[^<]+?>)*(?<fullsec>(?<section>\d.*?)(?:-.*?)*)(?:<[^<]+?>)*\)(?:<[^<]+?>)*)}) do |_m|
      caps = Regexp.last_match
      entry = caps[:entry].sub(/&minus;/, '-')	# this was interfering with link generation - ali(1) [AOS 4.3]
      %(#{caps[:break]}<a href="../man#{caps[:fullsec].downcase}/#{entry}.html">#{caps[:text]}</a>)
    end if style[:linkify]

  end

  def inspect
    <<~MSG

      +- Block (#{__id__}) class: #{self.class.name}
      |
      |  style: #{@style.inspect.each_line.collect { |l| l }.join('|         ')}
      |  text:  #{@text.inspect.each_line.collect { |l| l }.join('|         ')}
      |
    MSG
  end

  alias concat <<
  alias type= immutable_setter

  private

  # override this from Immutable so that our subclasses
  # don't all try to dispatch their own unique exceptions
  def get_object_exception_class
    Kernel.const_get("ImmutableBlockError")
  end

end
