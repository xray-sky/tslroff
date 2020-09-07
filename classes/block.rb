# Created by R. Stricklin <bear@typewritten.org> on 10/11/17.
# Copyright 2017 Typewritten Software. All rights reserved.
#
#
# Block class
#

require 'forwardable'
require 'modules/immutable.rb'
require 'classes/style.rb'
require 'classes/text.rb'

class Block
  include Immutable
  extend Forwardable

  attr_reader   :text, :type
  attr_accessor :style
  def_delegators :@style, :immutable?, :immutable!

  def initialize(arg = Hash.new)
    self.style = (arg[:style] or Style.new({}, get_object_exception_class))
    self.type  = (arg[:type]  or :p)
    self.text  = (arg[:text]  or Text.new)
  end

  def <<(t)
    case t
    when Text   then @text << t
    when String then @text.last << t
    when LineBreak
      cur_fmt =  @text.last.respond_to?(:font) ? Text.new(font: @text.last.font.dup, style: @text.last.style.dup) : Text.new
      @text << t << cur_fmt
    when Block  # this is primarily meant for handling named strings, which may include typesetter escapes
      raise RuntimeError "appending non-bare block #{t.inspect}" unless t.type == :bare
      @text += t.text
      # don't leave the last text object open, or else you'll start writing into the named string definition.
      @text << Text.new(font: text.last.font.dup, style: text.last.style.dup)
    end
    (immutable! and @output_indicator = true) unless t.empty?
  end

  def empty?
    #text.collect(&:to_s).join.strip.empty?  # REVIEW: does this even make sense?
    type == :comment or text.reject(&:empty?).none?
  end

  def inspect
    <<~MSG

      +- Block (#{__id__}) type: #{@type.inspect}
      |
      |  style: #{@style.inspect.each_line.collect { |l| l }.join('|         ')}
      |  text:  #{@text.inspect.each_line.collect { |l| l }.join('|         ')}
      |
    MSG
  end

  def text=(t)
    @text = t.is_a?(Array) ? t : [t]
    immutable! unless t.empty?
    @output_indicator = !text.empty?
  end

  def output_indicator?
    @output_indicator
  end

  def reset_output_indicator
    @output_indicator = false
  end

  def to_html             # TODO: this needs more work to leave <!-->, etc. open for subsequent output
    #return if empty? and ![:cell, :comment].include?(type)  # don't eat comments or empty table cells.
    t = text.collect(&(type == :comment ? :to_s : :to_html)).join
    case type
    when :nil     then '' # suppress. used for placeholding in tbl.
    when :bare    then t
    when :nroff   then %(<div class="body"><div id="man"><pre class="n">#{t}</pre></div></div>) # TODO maybe something with a gutter instead of breaking html with multiple id=man
    when :comment then %(<!--#{t} -->\n)
    when :table   then "<table#{style.to_s}>\n#{t}</table>\n"
    when :row     then " <tr#{style.to_s}>\n#{t}</tr>\n"
    when :row_adj then "</tr>\n<tr#{style.to_s}>\n#{t}" # for adjusting tbl rows after _ and =
    when :th      then %(<div class="title"><h1>#{t}</h1></div>\n<div class="body">\n    <div id="man">\n)
    when :sh      then "<h2>#{t}</h2>\n"
    when :ss      then "<h3>#{t}</h3>\n"
    when :se      then %(<html><head><link rel="stylesheet" type="text/css" href="#{$CSS}"></link></head><body><div id="man"><span id="selenium">#{t}</span></div></body></html>)
    when :cell
      t.gsub!(/&tblctl_\S+?;/) do |e|
        case e
        when '&tblctl_nl;'  then %(<span style="width:#{style[:numeric_align][:left].call}em;text-align:right;display:inline-block;">)
        when '&tblctl_nr;'  then %(<span style="width:#{style[:numeric_align][:right].call}em;display:inline-block;">)
        when '&tblctl_ctr;' then %(<span style="width:100%;display:inline-block;text-align:center;">)
        else warn "unimplemented #{e}"
        end
      end
      "  <td#{style.to_s}>#{t}</td>\n"
    when :p
      #return if t.strip.empty?
      case style[:section]
      when 'SYNOPSIS'
        %(<p class="synopsis"#{style.to_s}>\n#{t}\n</p>\n)
      when Manual.related_info_heading
        # TODO this is getting into trouble when there are <br />, and enclosing it within the <a>
        #      (though everything else about it seems fine) -- see hf77(1), hc(1) [AOS-4.3]
        "<p#{style.to_s}>\n#{t.gsub(%r{((<[^<]+?>)*(\S+?)(<.+?>)*\((<.+?>)*((\d.*?)(-.*?)*)(<.+?>)*\)(<.+?>)*)},
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
