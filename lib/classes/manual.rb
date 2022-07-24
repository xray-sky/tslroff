# Created by R. Stricklin <bear@typewritten.org> on 05/14/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# Manual class
# Just a delegatation to input format specific methods
#

require 'pathname'
require_relative 'source.rb'
require_relative 'block.rb'
require_relative 'break.rb'
require_relative 'text.rb'

ManualIsBlacklisted = Class.new(RuntimeError)

class Manual

  attr_accessor :blocks # REVIEW: blocks, lines? where am I using those outside the class?
  attr_reader   :platform, :version, :magic,
                :manual_entry, :manual_section, :output_directory,
                :lines, :links

  def initialize(file, os, ver)
    @platform = os
    @version  = ver
    @input_filename   = File.basename(file)
    @source_dir       = File.dirname(file)
    # REVIEW: why did I stop initializing these?
    #@manual_entry     = String.new
    #@manual_section   = String.new
    #@output_directory = String.new
    @manual_entry     = @input_filename

    @document = []
    @related  = []

    @symlink = File.readlink(file) if File.symlink?(file)
    @source = Source.new(file)
    @lines = @source.lines.each
    @current_block = Block.new

    @magic = @source.magic
    require_relative "../modules/dom/#{@magic.downcase}"
    extend Kernel.const_get(@magic)

    source_init
  rescue Errno::ENOENT, Errno::EISDIR
    # these things should still be exceptions, if we aren't dealing with a symlink
    raise unless @symlink

    # broken symlink (or symlink to directory) -- defer this to platform override code
    # don't rely on anything that needs @source! (magic, parse_title, etc.)
    @lines = [].each
    load_platform_overrides
    load_version_overrides
  end

  def symlink?
    !@symlink.nil?
  end

  def apply(&block)
    yield
    rescue ImmutableBlockError
      @current_block = blockproto
      @document << @current_block
      retry
    rescue ImmutableTextError, ImmutableFontError
      @current_block << Text.new(font: @current_block.text.last.font.dup, style: @current_block.text.last.style.dup)
      retry
    rescue ImmutableStyleError => e
      warn "!!! rescuing #{e.class.name} (??)"
  end

  def load_platform_overrides
    platform_const = self.platform
    require_relative "../modules/platform/#{platform_const.downcase}.rb"
    # module name can't start with a digit; is trouble for 386BSD
    platform_const = "X#{platform_const}" if platform_const.match?(/^[0-9]/)
    extend Kernel.const_get(platform_const.gsub(/[^0-9A-Za-z]/, '_').to_sym)
  rescue LoadError => e
    nil
  end

  def load_version_overrides
    require_relative "../modules/platform/#{self.platform.downcase}/#{self.version}.rb"
    extend Kernel.const_get("#{self.platform}_#{self.version}".gsub(/[^0-9A-Za-z]/, '_').to_sym)
  rescue LoadError => e
    nil
  end

  def warn(m)
    super("#{@input_filename} [#{input_line_number}]: #{m}")
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
      # TODO: get @output_directory from .TH in Troff Manual.new (already done for Nroff Manual.new)
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

  def page_title
    "#{@manual_entry}(#{@manual_section}) &mdash; #{@platform} #{@version}"
  end

end
