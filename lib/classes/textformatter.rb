# frozen_string_literal: true
#

require_relative 'block'
require_relative 'text'
require_relative 'styles/block'
require_relative 'styles/control'
require_relative 'styles/eqntext'
#require_relative 'styles/pic'
require_relative 'styles/tab'

class TextFormatter
  attr_reader :manual_entry, :manual_section

  extend Forwardable
  def_delegators :@source, :magic, :file, :dir, :line_number, :next_line, :patch, :patch_line, :patch_lines

  def initialize(source, vendor_class: nil, source_args: nil)
    #@input_filename = source.file
    #@input_line_number = 0
    @source ||= source

    @language      ||= 'en' # English
    @manual_entry  ||= ''
    @related       ||= []
    @document      ||= []
    @current_block ||= Block.new

    @lines ||= @source.iter
  end

  def warn(msg)
    super("#{@warn_prefix}#{file} [#{line_number}]: #{msg}")
  end

  def page_title
    "#{@manual_entry}(#{@manual_section}) &mdash; #{@platform} #{@version}"
  end

  def apply(&block)
    yield
  rescue ImmutableBlockError
    @current_block = blockproto
    @document << @current_block
    retry
  rescue ImmutableTextError, ImmutableFontError
    @current_block << Text.new(font: @current_block.terminal_font.dup, style: @current_block.terminal_text_style.dup)
    retry
  rescue ImmutableStyleError => e
    warn "!!! rescuing #{e.class.name} (??)"
  end

end

