# Created by R. Stricklin <bear@typewritten.org> on 05/14/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# Manual class
# Just a delegation to input format specific methods
#
# TODO
# √ at some point I broke the way overriding @magic from platform/version overrides was working
#

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

class Manual

  attr_accessor :blocks # REVIEW blocks, lines? where am I using those outside the class?
  attr_reader   :platform, :version, :magic,
                :manual_entry, :manual_section, :output_directory,
                :language, :lines, :links

  def initialize(file, os, ver)
    @platform = os
    @version  = ver
    @input_filename   = File.basename(file)
    @source_dir       = File.dirname(file)
    # REVIEW why did I stop initializing these? - because I wanted them to happen in parse_title
    #@manual_entry     = String.new
    #@manual_section   = String.new
    #@output_directory = String.new
    @manual_entry     = @input_filename
    @language         = 'en' # English

    @document = []
    @related  = []

    @symlink = File.readlink(file) if File.symlink?(file)
    @source = Source.new(file)
    @current_block = Block.new

    doctype_extend

    @lines = @source.lines.each
    source_init
  rescue Errno::ENOENT, Errno::EISDIR
    # these things should still be exceptions, if we aren't dealing with a symlink
    raise unless @symlink

    # broken symlink (or symlink to directory) -- defer this to platform override code
    # don't rely on anything that needs @source! (magic, parse_title, etc.)
    @lines = [].each
    doctype_extend
  end

  def symlink?
    !@symlink.nil?
  end

  def warn(msg)
    super("#{@input_filename} [#{input_line_number}]: #{msg}")
  end

  def page_title
    "#{@manual_entry}(#{@manual_section}) &mdash; #{@platform} #{@version}"
  end

  def output_filename
    # REVIEW maybe this method also useful for related/symlink problems ?
    @manual_entry.tr('/', '_') # for coping with VMS pages e.g. EDIT vs. /EDIT
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

  # Try to establish some simplistic default behavior for
  # re-targeting symlinks which appear in the input
  def retarget_symlink
    link_dir = Pathname.new @source_dir
    target_dir = Pathname.new File.dirname(@symlink)
    real_target = File.realpath("#{@source_dir}/#{@input_filename}")

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
    warn "encountered unsupported link type, #{@source_dir}/#{@input_filename} => #{@symlink}"
  end

  def doctype_extend
    begin
      require_relative "../modules/platform/#{@platform.downcase}.rb"
      platform_module = Kernel.const_get(@platform.gsub(/[^0-9A-Za-z]/, '_').sub(/^([0-9])/, 'X\1').to_sym) # 386bsd is not a valid Constant REVIEW smrtr? .prepend("OS_")?
    rescue LoadError
      platform_module = nil
    end

    begin
      require_relative "../modules/platform/#{@platform.downcase}/#{@version}.rb"
      version_module = Kernel.const_get("#{@platform}_#{@version}".gsub(/[^0-9A-Za-z]/, '_').to_sym)
    rescue LoadError
      version_module = nil
    end

    # separate the require from the extend, to give us a chance to keep the platform/version
    # overrides in order when the automatic document type detection fails

    @magic = @source.magic # is this used anywhere other than below? - YES (in tslroff.rb) REVIEW is that useful to keep
    require_relative "../modules/dom/#{@magic.downcase}"

    extend Kernel.const_get(@magic)
    extend platform_module if platform_module
    extend version_module  if version_module
  end
end
