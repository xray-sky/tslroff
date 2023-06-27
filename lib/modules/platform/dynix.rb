# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/14/23.
# Copyright 2023 Typewritten Software. All rights reserved.
#
#
# DYNIX Platform Overrides (tmac.an.new)
#
# TODO
#

module DYNIX

  def self.extended(k)
    k.define_singleton_method(:LP, k.method(:PP)) if k.methods.include?(:PP)
    k.instance_variable_set '@manual_entry',
       k.instance_variable_get('@input_filename').sub(/\.(\d\S?)$/, '')
    k.instance_variable_set '@manual_section', Regexp.last_match[1]
    k.instance_variable_set '@output_directory', "man#{k.instance_variable_get '@manual_section'}"
    #k.instance_variable_get('@state')[:footer] = "\\*(]D\\0\\0\\(em\\0\\0\\*(]W"
    case k.instance_variable_get '@input_filename'
    when 'Makefile'
      raise ManualIsBlacklisted, 'not a manual entry'
    end
  end

  def init_ds
    super
    @state[:named_string].merge!(
      {
        # tmac.an.new
        footer: "\\*(]W",
        ']D' => "UNIX Programmer's Manual", # default set by .TH
        ']W' => '7th Edition', # default set by .TH
        #']W' => File.mtime(@source.filename).strftime("%B %d, %Y"),
        'V)' => ''
      }
    )
  end

  def init_tr
    super
    @state[:translate]['*'] = "\e(**"
  end

  # .so with absolute path, headers in /usr/include
  #def req_so(name, breaking: nil)
  #  osdir = @source_dir.dup
  #  @source_dir << '/..'
  #  super(name, breaking: breaking)
  #  @source_dir = osdir
  #end

  define_method 'TH' do |*args|
    req_rm '}C' if @state[:named_string]['V)'].empty?
    req_nr 'IN .5i'
    req_ds "]H #{args[0]}\\^(\\^#{args[1]}\\^)"
    req_ds "]L #{args[2]}"
    req_ds "]W Revision #{args[2]}"
    req_ds "]W #{args[3]}" if args[3] and !args[3].strip.empty?
    req_ds "]D Dynix Programmer's Manual" unless @state[:named_string]['V)'].empty?
    req_ds "]D #{args[4]}" if args[4] and !args[4].strip.empty?

    heading = "\\*(]H\\0\\0\\(em\\0\\0\\*(]D"
    @state[:named_string][:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @state[:named_string][']L'].empty?

    super(heading: heading)
  end

  # tmac.an.new
  define_method 'UC' do |v = '', *_args|
    req_ds(']W ' + case v
                   when ''  then '3rd Berkeley Distribution'
                   when '4' then '4th Berkeley Distribution'
                   else "#{args[1]} #{args[0]} BSD"
                   end
          )
  end

  define_method 'VE' do |*_args|
    warn ".VE can't yet draw margin characters (.mc)"
  end

  define_method 'VS' do |*_args|
    warn ".VS can't yet draw margin characters (.mc)"
  end

  define_method 'Ps' do |*args|
    warn "REVIEW .Ps #{args.inspect}"
    req_ft '5'
    req_sp
    req_nf
    req_in '+0.5i'
  end

  define_method 'Pe' do |*args|
    warn "REVIEW .Pe #{args.inspect}"
    req_sp
    req_fi
    req_in '-0.5i'
    req_ft 'P'
  end

end
