# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 08/23/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Kodak/SunSoft Interactive UNIX Platform Overrides
#
# TODO
#

module Interactive

  def self.extended(k)
    k.define_singleton_method(:LP, k.method(:PP)) if k.methods.include?(:PP)
    k.instance_variable_set '@heading_detection', %r(^\s{10}(?<section>[A-Z][A-Za-z\s]+)$)
    k.instance_variable_set '@title_detection', %r{^\s{10}(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))}
    k.instance_variable_set '@manual_entry',
      k.instance_variable_get('@input_filename').sub(/\.([n\d]\S*)$/, '')
    k.instance_variable_set '@manual_section', Regexp.last_match[1] if Regexp.last_match
  end

  def init_ds
    super
    @state[:named_string].merge!({
      'Tm' => '&trade;',
      'E'  => '\\&.\|.\|.',
      'T'  => "\t",
      # these are probably version 4 specific
      'U'  => 'INTERACTIVE UNIX System',
      'U2' => 'INTERACTIVE UNIX System',
      'UF' => 'INTERACTIVE UNIX System',
      'UH' => 'INTERACTIVE UNIX System',
      'UU' => 'INTERACTIVE UNIX System',
      'sA' => 'Base', # System Accounting Subset
      'sC' => 'Base', # Core Subset
      'sF' => 'Text Processing', # Text Formatting Subset
      'sG' => 'Base', # Games Subset
      'sI' => 'Base', # INpackages
      'sN' => 'Base', # Networking Subset
      'sP' => 'Software Development', # Programming Subset
      'sS' => 'Software Development', # SCCS Subset
      'sT' => 'Text Processing', # Typesetting and Terminal Filters Subset
      'Nn' => 'INTERACTIVE UNIX System 80386',
      ']D' => '', # blanked for troff in .TH
      ']L' => '', # conditionally defined in .TH
      ']U' => File.mtime(@source.filename).strftime("%B %d, %Y"),
      ']Y' => '\\*U',
      ']Z' => 'Version \\|1.0',
      :footer => '\\fB\\s-1\\*(]Y\\0\\0\\(em\\0\\0\\*(]Z\\s+1\\fP'
    })
  end

  def init_nr
    @register['PD'] = @register[')P']         # Interactive .PD sets \n(PD instead of \n()P
    @register[')f'] = Troff::Register.new(3)  # bold font (for some reason)
    @register[')t'] = Troff::Register.new(1)  # 8.5" x 11" format (notionally enable)
    @register[')s'] = Troff::Register.new(0)  # 6" x 9" format (notionally disable)
  end

  def init_ta
    @state[:tabs] = [ '3.6m', '7.2m', '10.8m', '14.4m', '18m', '21.6m', '25.2m', '28.8m',
                      '32.4m', '36m', '39.6m', '43.2m', '46.8m' ].collect { |t| to_u(t).to_i }
    true
  end

  def init_TH
    #super
    @register['IN'] = Troff::Register.new(@state[:base_indent])
  end

  # whoa, danger
  define_method 'Pp' do |*args|
    warn ".Pp attempting to include process output from #{args.inspect} ?!"
    #system "#{args[0]} #{args[1]} >/tmp/DIT.#{Process.pid}"
    #req_so "/tmp/DIT.#{Process.pid}"
    #File.delete "/tmp/DIT.#{Process.pid}"
  end

  define_method 'BA' do |*args|
    return nil.tap { warn ".BA has illegal number of args - #{args.inspect}" } unless args.any? and args.count < 3
    send 'RB', '[\\0', "\\&#{args[0]}", "#{args[1]}\\0]\\%"
  end

  define_method 'BX' do |*args|
   warn ".BX wants to draw box from #{args.inspect} - punt"
   unescape args.join(' ')
  end

  define_method 'IN' do |*args|
    parse "\\s-1INTERACTIVE\\s+1#{args[0]}"
  end

  define_method 'LR' do |*args|
    send 'SH', "LICENSE REQUIRED"
    parse "This entry applies only to the #{args[0]} license."
  end

  # small caps
  define_method 'SC' do |*args|
    req_ps
    if args.count > 2
      parse "#{args[0]}\\s-1#{args[1]}\\s+1#{args[2]}"
    elsif args.any?
      parse "\\s-1#{args[0]}\\s+1#{args[1]}"
    else
      req_ps "#{Font.defaultsize}-1"
      req_it '1 }f'
    end
  end

  define_method 'TH' do |*args|
    #req_ds "]H #{args[0]}\\^(\\^#{args[1]}\\^)"
    # cut mark stuff, output from }C, along with ]U and ]V
    #req_ds "]W Rev. #{args[2]}"
    #req_ds "]T #{args[3]}"
    req_ds("]L (\\^#{args[4]}\\^)") if args[4] and !args[4].strip.empty?

    heading = "#{args[0]}\\^(\\^#{args[1]}\\^)"
    heading << "\\0\\0\\(em\\0\\0\\*(]L" if @state[:named_string][']L']

    super(*args, heading: heading)
  end

  # 4.0 aborts when encountering these macros; we'll just warn
  def obsolete_macro(*args)
    warn "encountered obsolete macro #{__callee__}"
  end

  %w[PM DE DS SB VX].each do |m|
    alias_method m, :obsolete_macro
  end

end
