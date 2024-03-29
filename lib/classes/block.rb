# Created by R. Stricklin <bear@typewritten.org> on 10/11/17.
# Copyright 2017 Typewritten Software. All rights reserved.
#
#
# Block class
#

require 'forwardable'
require_relative 'style'
require_relative 'text'
require_relative '../modules/immutable'

class Block
  include Immutable
  extend Forwardable

  def_delegators :@style, :immutable?, :immutable!
  attr_reader   :text, :last_tab_position, :last_tab_stop
  attr_accessor :style

  def initialize(arg = {})
    self.style = (arg[:style] or Style.new({}, object_exception_class))
    self.text  = (arg[:text]  or Text.new)
    @last_tab_position = 0
    @last_tab_stop = 0
  end

  def empty?
    text.reject(&:empty?).none?
  end

  def text=(txt)
    immutable! unless txt.empty?
    @text = txt.is_a?(Array) ? txt : [txt]
  end

  # REVIEW smrtr? - does everything we might append to text[] have a style / font ?
  #   one potential snag is what happens if we ever have a brand new Block with text == []
  def terminal_text_obj   ; @text.last       ; end
  def terminal_string     ; @text.last.text  ; end
  def terminal_font       ; @text.last.font  ; end
  def terminal_text_style ; @text.last.style ; end

  # REVIEW I guess I did this to myself. is there a "cleverer" way to have done this?
  def terminal_text_obj=(arg)   ; @text.last = arg       ; end
  def terminal_string=(arg)     ; @text.last.text = arg  ; end
  def terminal_font=(arg)       ; @text.last.font = arg  ; end
  def terminal_text_style=(arg) ; @text.last.style = arg ; end

  def <<(t)
    case t
    when Tab # insert_tab does its own hold/append, since it changes @text.last
      @text << t
      @last_tab_position = t.stop
      @last_tab_stop = @text.count
    when RoffControl, EqnBlock # don't leave this as the last bit of text, or it'll eat appends to @text
      # we might be at the very start of Block when @text is still [] - TODO some smarter strategy
      @text << t
      if t.is_a? LineBreak or t.is_a? VerticalSpace
        @last_tab_position = 0
        @last_tab_stop = @text.count
      end
      @text << Text.new(font: @text.last&.font.dup || Font::R.new, style: @text.last&.style.dup || Style.new)
    when Text, Block::TableCell, Block::Inline then @text << t
    when String then @text.last << t
    when Block # cruft catcher
      raise RuntimeError "appending non-bare block #{t.inspect}" #unless t.class == Block::Bare # bare blocks used by vms for inserting pre-formatted html; TODO probably create a Link text class
      warn "we are in a degenerate part of the code - block.rb line 91"
      @text += t.text
      # don't leave the last text object open, or else you'll start writing into the named string definition.
      @text << Text.new(font: @text.last&.font.dup || Font::R.new, style: @text.last&.style.dup || Style.new)
    end
    immutable! unless t.empty?
  end

  def coerce(obj)
    [ Block.new(text: obj), self ]
  end

  def to_s
    text.collect(&:to_s).join
  end

  def to_selenium
    %(data:text/html;charset=utf-8,<html><head><link rel="stylesheet" type="text/css" href="#{$CSS}"></link></head><body><div id="man"><span id="selenium">#{to_html}</span></div></body></html>)
  end

  def to_html
    warn "we are in a degnerate part of the code - base class Block.to_html()"
    # TODO this needs more work to e.g. leave <!-->, etc. open for subsequent output, but stay whitespace safe (don't introduce whitespace by inserting newlines, etc.)
    # TODO don't output a <p> just for a comment - see ct(7) HP-UX 6.00
    # TODO we are still getting empty <p> in some circumstances - see ct(7) HP-UX 6.00
    t = text.collect(&(type == :comment ? :to_s : :to_html)).join

    # insert related information references
    # REVIEW am I going to need to make overrides to this regexp?
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
  def object_exception_class
    Kernel.const_get("ImmutableBlockError")
  end

end
