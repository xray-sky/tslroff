# frozen_string_literal: true
#
# Created by R. Stricklin <bear@typewritten.org> on 05/14/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# Manual class
#  interface specification for format-specific implementations
#

require 'forwardable'
require 'pathname'
require_relative 'block'
require_relative 'source'
require_relative 'text'
require_relative 'styles/block'
require_relative 'styles/control'
require_relative 'styles/eqntext'
#require_relative 'styles/pic'
require_relative 'styles/tab'
#require_relative '../modules/dom/nroff'
#require_relative '../modules/dom/troff'
#require_relative '../modules/dom/html'
#require_relative '../modules/dom/unknown'

ManualIsBlacklisted = Class.new(RuntimeError)

class TextFormatter
  attr_reader :input_line_number, :manual_entry, :manual_section

  extend Forwardable
  def_delegators :@source, :magic, :patch, :patch_line, :patch_lines

  def initialize(source, vendor_class: nil, source_args: nil)
    @input_filename = source.file
    @input_line_number = 0
    @source ||= source

    @language      ||= 'en' # English
    @manual_entry  ||= ''
    @related       ||= []
    @document      ||= []
    @current_block ||= Block.new

    @lines ||= @source.lines.each
  end

  def warn(msg)
    super("#{@source.file} [#{input_line_number}]: #{msg}")
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

require_relative '../modules/dom/unknown'
require_relative '../modules/dom/html'
require_relative '../modules/dom/troff'
require_relative '../modules/dom/groff'
require_relative '../modules/dom/nroff'

class Manual
  attr_accessor :blocks # REVIEW blocks, lines? where am I using those outside the class?
  attr_reader   :language, :lines, :links

  extend Forwardable
  def_delegators :@source, :link?, :magic, :patch, :patch_line, :patch_lines
  def_delegators :@document, :to_html, :page_title, :manual_entry, :manual_section, :output_directory, :xpath

  def initialize(file, vendor_class: nil, source_args: nil, preprocess: nil, &block)
    @input_filename = file
    @input_line_number = 0
    @source ||= Source.new file, source_args, &block
    document_class = Kernel.const_get "#{vendor_class}::#{@source.magic}"

    send preprocess if preprocess
    @document ||= document_class.send :new, @source

    #@platform ||= os
    #@version  ||= ver
    # REVIEW why did I stop initializing these? - because I wanted them to happen in parse_title
    #@manual_entry     = String.new
    #@manual_section   = String.new
    #@output_directory = String.new
    #@manual_entry     ||= @source.file
    #@document ||= []

    @language      ||= 'en' # English
    @related       ||= []
    @lines         ||= @source.lines.each
    @current_block ||= Block.new

    #@document.source_init # TODO this is why I have to ||= the init. do better.
    # >>> was just parse_title: (REVIEW check vendor overrides though)
    parse_title
  rescue Errno::ENOENT, Errno::EISDIR
    # these things should still be exceptions, if we aren't dealing with a symlink
    raise unless @symlink

    # broken symlink (or symlink to directory) -- defer this to platform override code
    # don't rely on anything that needs @source! (magic, parse_title, etc.)
    @lines ||= [].each
  end

  # this is a Manual method, not (was) a Troff method.
  # REVIEW check for others that ought to move too
  # REVIEW maybe it should continue being a Troff method after all.
  def parse_title
    # parse as far as the title, so we can have the odir immediately after
    # a Manual.new, then if we want to continue (aren't just figuring out
    # a symlink target), then just continue on.
    to_html(halt_on: '@manual_section') #or warn "reached end of document without finding title!"
    #@output_directory = "man#{manual_section.downcase}" if manual_section
  end

  def output_filename
    # REVIEW maybe this method also useful for related/symlink problems ?
    manual_entry.tr('/', '_') # for coping with VMS pages e.g. EDIT vs. /EDIT
  end

  # Try to establish some simplistic default behavior for
  # re-targeting symlinks which appear in the input
  def retarget_symlink
    link_dir = Pathname.new @source.dir
    target_dir = Pathname.new File.dirname(@symlink)
    real_target = File.realpath("#{link_dir}/#{@input_filename}")

    # classes of links
    # do:     links to files with different names in same directory
    # do not: links to subdirectories with different names in same directory
    if (link_dir + target_dir) == link_dir and File.file?(real_target)
      # instantiating target to get any local transforms on @manual_entry (which is based on input file name)
      # TODO get @output_directory from .TH in Troff Manual.new (already done for Nroff Manual.new)
      target_entry = Manual.new(real_target, @platform, @version)
      return { link: "#{@manual_entry}.html",
               target: "#{target_entry.manual_entry}.html" }
    end

    # do not: links to files with same name in different directory
    #         assume the real files will be in the args somewhere and skip the links
    # do not: directory links
    #         should be skipped in normal unix manual based on output structure
    #         and above scenario. some platforms may require (apollo)
    # do not: links to files with different name in different directory
    #         some platforms may require (apollo)
    # do not: other platform specific oddities, apparently broken links, etc.
    #         ./sys5.3/usr/catman/u_man/man5/xterm.5 -> ../../../../../usr/X11/man/cat7/xterm.7
    #   ./sys/help/protection/protected_subsystems.hlp -> /protected_subs.hlp
    warn "encountered unsupported link type, #{link_dir}/#{@input_filename} => #{@symlink}"
  end

end

Dir.glob(%w[../modules/platform/*.rb ../modules/platform/**/*.rb], base: File.dirname(__FILE__)).each do |i|
  require_relative i
end

