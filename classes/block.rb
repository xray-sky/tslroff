# Created by R. Stricklin <bear@typewritten.org> on 10/11/17.
# Copyright 2017 Typewritten Software. All rights reserved.
#
#
# Block class
#

require 'modules/immutable.rb'
require 'classes/style.rb'
require 'classes/text.rb'

class Block
  include Immutable

  attr_reader   :text, :type
  attr_accessor :style

  def initialize(arg = Hash.new)
    self.type  = (arg[:type]  or :p)
    self.style = (arg[:style] or Style.new({}, get_object_exception_class))
    self.text  = (arg[:text]  or Text.new)
  end

  def <<(t)
    case t
    when String then @text.last << t
    when Text   then @text << t
    when Block  # this is primarily meant for handling named strings, which may include typesetter escapes
      raise RuntimeError "appending non-bare block #{t.inspect}" unless t.type == :bare
      @text += t.text
      # don't leave the last text object open, or else you'll start writing into the named string definition.
      @text << Text.new(font: text.last.font.dup, style: text.last.style.dup)
    end
    freeze unless t.empty?
  end

  def empty?
    text.collect(&:to_s).join.strip.empty?  # REVIEW: does this even make sense?
  end

  def freeze
    is_frozen? or style.freeze
  end

  def is_frozen?
    instance_variable_defined?(:@style) ? style.is_frozen? : nil
  end

  def inspect
    "+- Block (#{__id__}) type: #{@type.inspect}\n|\n|  style: " +
    @style.inspect.each_line.collect { |l| l }.join("|         ") + "\n|  text: " +
    @text.inspect.each_line.collect { |l| l }.join("|         ") + "\n|\n"
  end

  def text=(t)
    @text = t.is_a?(Array) ? t : [t]
    freeze unless t.empty?
  end

  def to_html             # TODO: this needs more work to leave <dl>, <!-->, etc. open for subsequent output
    return if empty?
    t = type == :comment ? text.collect(&:to_s).join : text.collect(&:to_html).join
    case type
    when :nil     then '' # suppress. used for placeholding in tbl.
    when :bare    then t
    when :comment then %(<!--#{t} -->\n)
    when :table   then "<table#{style.to_s}>\n#{t}</table>\n"
    when :row     then " <tr#{style.to_s}>\n#{t}</tr>\n"
    when :row_adj then "</tr>\n<tr#{style.to_s}>\n#{t}" # for adjusting tbl rows after _ and =
    when :cell    then "  <td#{style.to_s}>#{t}</td>\n"
    when :th      then %(<div class="title"><h1>#{t}</h1></div>\n<div class="body">\n    <div id="man">\n)
    when :sh      then "<h2>#{t}</h2>\n"
    when :ss      then "<h3>#{t}</h3>\n"
    when :dl      then "<dl#{style.to_s}>\n <dt#{style[:dt].style.to_s}>#{style[:dt].to_html}</dt>\n  <dd#{style[:dd].style.to_s}>#{t}</dd>\n</dl>\n" # FIXME: this crashes if 'tag' is unset.
    when :se      then %(<html><head><link rel="stylesheet" type="text/css" href="#{$CSS}"></link></head><body><div id="man"><span id="selenium">#{t}</span></div></body></html>)
    when :p
      return if t.strip.empty?
      case style[:section]
      when 'SYNOPSIS'
        %(<p class="synopsis"#{style.to_s}>\n#{t}\n</p>\n)
      when 'SEE ALSO' # TODO: this needs to be platform overrideable; section to lowercase (maybe?)
        "<p#{style.to_s}>\n#{t.gsub(/((<.+?>)*(\S+?)(<.+?>)*\((<.+?>)*((\d.*?)(-.*?)*)(<.+?>)*\)(<.+?>)*)/,
          %(<a href="../man\\7/\\3.\\6.html">\\1</a>))}\n</p>\n"
      else
        "<p#{style.to_s}>\n#{t}\n</p>\n"
      end
    else          %(<p style="color:gray;">BLOCK(#{type})<br>#{t}</p>\n)
    end
  end

  def to_s
    text.collect(&:to_s).join
  end

  def to_selenium
    return %(data:text/html;charset=utf-8,<html><head><link rel="stylesheet" type="text/css" href="#{$CSS}"></link></head><body><div id="man"><span id="selenium">#{to_html}</span></div></body></html>)
  end

  alias concat <<
  alias type= immutable_setter
end
