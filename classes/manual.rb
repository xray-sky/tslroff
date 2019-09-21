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
  attr_reader   :platform, :version, :lines, :links

  def initialize(file)
    # TODO: temporary hardcode for early prototyping
    @platform = 'SunOS'
    @version  = '4_1_4'
    # end temporary hardcode

    @document = Array.new
    @related  = Array.new

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
        @current_block = blockproto
        @document << @current_block
        retry
      when ImmutableTextError, ImmutableFontError
        @current_block << Text.new(font: @current_block.text.last.font.dup, style: @current_block.text.last.style.dup)
        retry
      else warn "!!! rescuing #{e.class.name} (??)"
      end
    end
  end

end
