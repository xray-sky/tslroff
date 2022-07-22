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

  attr_reader   :text, :type
  attr_accessor :style
  def_delegators :@style, :immutable?, :immutable!

  def initialize(arg = Hash.new)
    self.style = (arg[:style] or Style.new({}, get_object_exception_class))
    self.type  = (arg[:type]  or :p)
    self.text  = (arg[:text]  or Text.new)
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
    when Text   then @text << t
    when String
      if text.last.text.respond_to?(:<<)
        @text.last << t
      else
       brk = Text.new(font: text.last.font.dup, style: text.last.style.dup)
       brk[:tab_stop] = 0
       brk.text = t
       @text << brk
      end
    when LineBreak
      brk = Text.new(font: text.last.font.dup, style: text.last.style.dup)
      brk[:tab_stop] = 0
      brk.text = t
      @text << brk
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

    case type
    when :nil     then '' # suppress. used for placeholding in tbl.
    when :bare    then t
    when :nroff   then %(<div class="body"><div id="man"><pre class="n">#{t}</pre></div></div>) # TODO maybe something with a gutter instead of breaking html with multiple id=man
    when :comment then %(<!--#{t} -->\n)	# TODO: as a block, this is breaking up blocks that shouldn't be broke up! as(1) [SunOS 5.5.1]
    when :table   then "<table#{style.to_s}>\n#{t}</table>\n"
    when :row     then " <tr#{style.to_s}>\n#{t}</tr>\n"
    when :row_adj then "</tr>\n<tr#{style.to_s}>\n#{t}" # for adjusting tbl rows after _ and =
    when :th      then %(<div class="title"><h1>#{t}</h1></div>\n<div class="body">\n    <div id="man">\n)
    when :subhead then %(<p class="subhead">#{t}</p>\n)
    when :sh      then "<h2>#{t}</h2>\n"
    when :ss      then "<h3>#{t}</h3>\n"
    when :ss_alt  then "<h4>#{t}</h4>\n"
    when :cs      then "<pre>#{t}</pre>\n"
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
      case style[:section]
      when 'SYNOPSIS'
        %(<p class="synopsis"#{style.to_s}>\n#{t}\n</p>\n)
      #when Manual.related_info_section # TODO: this is broke for overriding on a page basis. see also: Troff, Nroff
      #  links = t.gsub(%r{(?<text>(?:<[^<]+?>)*(?<entry>\S+?)(?:<.+?>)*\((?:<.+?>)*(?<fullsec>(?<section>\d.*?)(?:-.*?)*)(?:<.+?>)*\)(?:<.+?>)*)}) {
      #            #(text, dir, section) = [$1, $7.downcase, $6.downcase]
      #            caps = Regexp.last_match
      #            entry = caps[:entry].sub(/&minus;/, '-')	# this was interfering with link generation - ali(1) [AOS 4.3]
      #            #%(<a href="../man#{dir}/#{entry}.#{section}.html">#{text}</a>)
      #            #%(<a href="../man#{matches[:section].downcase}/#{entry}.#{matches[:fullsec].downcase}.html">#{matches[:text]}</a>)
      #            %(<a href="../man#{caps[:fullsec].downcase}/#{entry}.html">#{caps[:text]}</a>)
      #            # <br /> tags still causing problems; just not so severe? - tftp(1c) [AOS 4.3]
      #          }
      #  "<p#{style.to_s}>\n#{links}\n</p>\n"
      else
        "<p#{style.to_s}>\n#{t}\n</p>\n"
      end
    else          %(<p style="color:gray;">BLOCK(#{type})<br>#{t}</p>\n)
    end
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

  alias concat <<
  alias type= immutable_setter
end
