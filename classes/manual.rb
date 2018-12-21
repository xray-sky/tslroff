# Created by R. Stricklin <bear@typewritten.org> on 05/14/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# Manual class
# Just a delegatation to platform-specific methods
#

require 'classes/enumerator/collect_through.rb'
require 'classes/source.rb'
require 'classes/block.rb'
require 'classes/text.rb'

class Manual
  attr_accessor :blocks
  attr_reader   :platform, :version, :lines

  def initialize(file)
    # TODO: temporary hardcode for early prototyping
    @platform = 'SunOS'
    @version  = '4_1_4'
    # end temporary hardcode

    @blocks = Array.new
    @source = Source.new(file)
    @lines  = @source.lines.each
    @current_block = Block.new

    require "modules/dom/#{@source.magic.downcase}"
    extend Kernel.const_get(@source.magic.to_sym)

    source_init
  end

  def apply(&block)
    begin
      yield
    rescue ImmutableBlockError, ImmutableTextError, ImmutableFontError, ImmutableStyleError => e
      case e
      when ImmutableBlockError
        @blocks << @current_block
        @current_block = Block.new(style: @current_block.style.dup)
        retry
      when ImmutableTextError, ImmutableFontError
        @current_block << Text.new(font: @current_block.text.last.font.dup, style: @current_block.text.last.style.dup)
        retry
      else warn "!!! rescuing #{e.class.name} (??)"
      end
    end
  end

  # unit conversions
  #
  # this ought to be a class method except it needs to know what the current font size
  # and vertical spacing are. input units are converted to inches, then to whatever was requested
  #
  # REVIEW: these conversions aren't particularly sophisticated. maybe they don't need to be?
=begin
  def scale(value, units)

    (out, scale) = if value.match(/^([+\d\.\-\]+)(\w)$/)
                     Regexp.last_match[1..2]
                   else
                     [ value, 'n' ]
                   end

    ps = req_nr('.s')
    vs = @state[:
    case scale
    when 'm' then out *= ( ps / 72 )             # em
    when 'n' then out *= ( 0.5 * ( ps / 72 )     # en
    when 'v' then
    end
  end
=end
end
