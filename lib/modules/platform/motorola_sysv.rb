# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Motorola SysV Platform Overrides
#
# Defines .TX but with all SunOS titles. Leave it out.
# Uses \f4 like CX-UX 6.20. Probably related.
#
# TODO pic - allocb(3d), dupb(3d), linkb(3d)
# TODO
#   options to TH happening oddly - no arg[1] for section??
#   a few pages want to .rm }C for some reason
#

module Motorola_SysV

  def self.extended(k)
    #k.instance_variable_set '@heading_detection', %r{^\s{2,3}(?<section>[A-Z][A-Za-z\s]+)$}
    #k.instance_variable_set '@title_detection', %r{^\s{2,3}(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))}		# REVIEW now what?
    #k.instance_variable_set '@lines_per_page', 67
    k.define_singleton_method(:LP, k.method(:PP)) if k.methods.include?(:PP)
    k.instance_variable_set '@manual_entry',
      k.instance_variable_get('@input_filename').sub(/\.(\d\S?)$/, '')
    k.instance_variable_set '@manual_section', Regexp.last_match[1] if Regexp.last_match
  end

# looks like none of this matters much, as the provided pages are all nroff format except for X11.
  def init_ds
    super
    @state[:named_string].merge!({
      #'Tm' => '&trade;',
      # DocString_MOT
      'sS' => 'UNIX',
      'sl' => 'UNIX SYSTEM V/68 or V/88 Release 4',
      'sL' => 'UNIX SYSTEM V/68 or V/88 Release 4',
      's3' => 'UNIX SYSTEM V/68 and V/88 Release 4',
      's4' => 'UNIX SYSTEM V/68 and V/88 Release 4',
      's1' => 'UNIX SYSTEM V/68',
      's2' => 'UNIX SYSTEM V/88',
      'hC' => 'Motorola',
      'hs' => 'M68000 or M88000 family of processors',
      'h1' => 'M68000 family of processors',
      'h2' => 'M68000 family of processors',
      'h4' => 'M68000 family of processors',
      'h3' => 'M88000 family of processors',
      'hl' => 'supported Delta Series and DeltaSERVER platforms',
      'rp' => 'platform',
      # For internal Motorola use only
      'rL' => 'RM01',
      #']W' => "(last mod. #{File.mtime(@source.filename).strftime("%B %d, %Y")})",
      ']W' => '',
      :footer => "\\*(]W"
    })
  end

  def init_fp
    super
    # REVIEW
    @state[:fonts][4] = 'BI'
    @state[:fonts][5] = 'CW'
  end

  def init_tr
    super
    @state[:translate]['*'] = "\e(**"
  end

  def init_TH
    #super
    @register['IN'] = Troff::Register.new(@state[:base_indent])
  end

  define_method 'TH' do |*args|
    req_ds ']D ' + case args[1]&.strip
                   when '1'  then 'USER COMMANDS '
                   when '1C' then 'BASIC NETWORKING COMMANDS'
                   when '1F' then 'FMLI UTILITIES'
                   when '1G' then 'GOLD UTILITIES'
                   when '1M' then 'ADMINISTRATOR COMMANDS '
                   when '2'  then 'SYSTEM CALLS'
                   when '3'  then 'LIBRARY FUNCTIONS'
                   when '3C' then 'C LIBRARY FUNCTIONS'
                   when '3E' then 'ELF LIBRARY FUNCTIONS'
                   when '3G' then 'GENERAL LIBRARY FUNCTIONS'
                   when '3M' then 'MATHEMATICAL LIBRARY'
                   when '3N' then 'NETWORK FUNCTIONS'
                   when '3S' then 'STANDARD I/O FUNCTIONS'
                   when '3X' then 'MISCELLANEOUS LIBRARY FUNCTIONS'
                   when '4'  then 'FILE FORMATS'
                   when '5'  then 'PUBLIC FILES, TABLES, AND TROFF MACROS'
                   when '7'  then 'SPECIAL FILES AND DEVICES'
                   when 'L'  then 'LOCAL COMMANDS'
                   else 'MISC. REFERENCE MANUAL PAGES'
                   end
    req_ds "]L #{args[2]}"
    req_ds "]W #{args[3]}" if args[3] and !args[3].strip.empty?
    req_ds "]D #{args[4]}" if args[4] and !args[4].strip.empty?

    heading = "#{args[0]}\\|(\\|#{args[1]}\\|)\\0\\0\\(em\\0\\0\\*(]D"
    @state[:named_string][:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @state[:named_string][']L'].empty?

    super(*args, heading: heading)
  end

  define_method 'VE' do |*args|
    # .if '\\$1'4' .mc \s12\(br\s0
    # draws a 12pt box rule as right margin character
    warn "can't yet .VE #{args.inspect}"
  end

  define_method 'VS' do |*args|
    # .mc
    # clears box rule margin character
    warn "can't yet .VS #{args.inspect}"
  end
end

