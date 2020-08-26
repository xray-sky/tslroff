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

  attr_reader   :text, :font, :style
  #attr_accessor :font, :style

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
    return if is_frozen?
    font.freeze
    style.freeze
  end

  def is_frozen?
    [ :@font, :@style ].collect do |x|
      (instance_variable_defined?(x) ? instance_variable_get(x).send(:is_frozen?) : nil)
    end.compact.any?
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
    # TODO: some or most of this should probably be made troff-specific (somehow)
    return '' if length.zero?

    # tab separately, as it may encompass several Text objects
    # this relies on all other spans being closed tidily within a single Text object
    tab = @tab_width ? %(<span class="tab" style="width:#{@tab_width};">) : ''

    # font face & size; TODO: family
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
        when :baseline         then %(<span style="position:relative;top:#{v}em;line-height:0;">)
        when :horizontal_shift then %(<span style="position:relative;left:#{v}em;">)
        when :unsupported      then %(<span style="color:red;">Unsupported request =&gt; )
        else                        %(<span style="color:white;background:red;">WTF? #{t}: #{v} =&gt; )
        end
      end
    end

    # Multiple inter-word space characters found in the input are retained. §4.1
    ent = text.dup
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

    # translate some troff fill/adjust fluff
    ent.gsub!(/&roffctl_\S+?;/) do |e|
      case e
      when '&roffctl_endspan;'  then '</span>'
      when '&roffctl_unsupp;'   then '<span class="u">'
      when '&roffctl_nrs;'      then '<span class="nrs"></span>'
      when '&roffctl_hns;'      then '<span class="hns"></span>'
      when '&roffctl_tbl_nr;'   then '<span class="nalign">'
      when '&roffctl_tbl_nl;'   then '<span class="nalign" style="text-align:right">'
      when /&roffctl_hs:(.+?);/ then %(<span class="tab" style="width:#{Regexp.last_match(1)};"></span>)
      when /&roffctl_vs:(.+?);/ then %(<span class="vs" style="height:#{Regexp.last_match(1)};"></span>)
      when /&roffctl_.+;/       then '' # ignore any other roffctl code
      else warn "unimplemented #{e}"
      end
    end

    # mark it up the rest of the way
    # REVIEW what is the point of this isolated reference to @break? and where does the tab span get closed??
    (@break ? '<br />' : '') + tab + (tags + [ent] + (tags.reverse.map { |t| t.sub(/^</, '</').sub(/\s.*/, '>') })).join
  end

  def to_selenium
    # TODO consolidate this filesystem reference to the stylesheet
    %(data:text/html;charset=utf-8,<html><head><link rel="stylesheet" type="text/css" href="#{$LOAD_PATH}/tslroff.css"></link></head><body><div id="man"><span id="selenium">#{to_html}</span></div></body></html>)
  end

  alias concat <<
  alias font= immutable_setter
  alias style= immutable_setter
end
