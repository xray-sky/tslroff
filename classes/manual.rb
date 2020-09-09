# Created by R. Stricklin <bear@typewritten.org> on 05/14/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# Manual class
# Just a delegatation to input format specific methods
#

require 'classes/enumerator/collect_through.rb'
require 'classes/source.rb'
require 'classes/block.rb'
require 'classes/break.rb'
require 'classes/text.rb'

class Manual

  attr_accessor :blocks
  attr_reader   :platform, :version, :lines, :links

  def initialize(file, os, ver)
    @platform = os
    @version  = ver
    @input_filename = File.basename(file)
    @source_dir     = File.dirname(file)

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

  def load_platform_overrides
    platform_overrides = "modules/platform/#{self.platform.downcase}.rb"
    if File.readable?("#{__dir__}/../#{platform_overrides}")
      require platform_overrides
      extend Kernel.const_get(self.platform.gsub(/[^0-9A-Za-z]/, '_').to_sym)
    end
  end

  def load_version_overrides
    version_overrides = "modules/platform/#{self.platform.downcase}/#{self.version}.rb"
    if File.readable?("#{__dir__}/../#{version_overrides}")
      require version_overrides
      extend Kernel.const_get("#{self.platform}_#{self.version}".gsub(/[^0-9A-Za-z]/, '_').to_sym)
    end
  end

  def warn(m)
    super("#{@input_filename} [#{input_line_number}]: #{m}")
  end

  def self.related_info_heading
    'SEE ALSO'
  end

end
