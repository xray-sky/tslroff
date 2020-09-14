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

  def initialize(arg = Hash.new)
    self.font  = (arg[:font]  or Font.new)
    self.style = (arg[:style] or Style.new({}, get_object_exception_class))
    self.text  = (arg[:text]  or String.new)
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

      font:  [ #{font.inspect} ]
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
    return '<br />' if text.is_a?(LineBreak)
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
            else %(<span class="u">unknown font face #{font.face.inspect} =&gt; )
            end
    tags << %(<span style="font-size:#{font.size}pt;">) unless font.size.to_i == Font.defaultsize
    if @style.keys.any?
      tags += style.collect do |t, v| # TODO consolidate multiple styles??
        case t
        when :baseline         then %(<span style="position:relative;top:#{v}em;line-height:0;">)
        when :horizontal_shift then %(<span style="position:relative;left:#{v}em;">)
        when :word_spacing     then %(<span style="word-spacing:#{v}em;">) # REVIEW this seems to give wider spaces than I'd expect - jot(1) [AOS-4.3]
        when :eqn              then %(<span style="color:steelblue;">)
        when :unsupported      then %(<span class="u">Unsupported request =&gt; )
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
    # REVIEW where does the tab span get closed?? it seems to be, but..?
    tab + (tags + [ent] + (tags.reverse.map { |t| t.sub(/^</, '</').sub(/\s.*/, '>') })).join
  end

  alias concat <<
  alias font= immutable_setter
  alias style= immutable_setter
end
