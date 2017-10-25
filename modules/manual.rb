# Created by R. Stricklin <bear@typewritten.org> on 05/14/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# Manual class
# Just a delegatation to platform-specific methods
#

require 'modules/source.rb'
require 'modules/block.rb'
require 'modules/text.rb'

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

    require "dom/#{@source.magic.downcase}"
    extend Kernel.const_get(@source.magic.to_sym)

    source_init
  end

  def apply(&block)
    begin
      yield
    rescue ImmutableObjectError => e
      case e.control
      when :Block
        @blocks << @current_block
        @current_block = Block.new(style: @current_block.style.dup)
        retry
      when :Text
        @current_block << Text.new(font: @current_block.text.last.font.dup, style: @current_block.text.last.style.dup)
        retry
      end
    end
  end
end
