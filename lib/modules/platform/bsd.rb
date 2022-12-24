# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 09/04/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# BSD Platform Overrides (tmac.an.new)
#
# TODO
#

module BSD

  def self.extended(k)
    k.define_singleton_method(:LP, k.method(:PP)) if k.methods.include?(:PP)
    k.instance_variable_set '@manual_entry',
       k.instance_variable_get('@input_filename').sub(/\.(\d\S?)$/, '')
    k.instance_variable_set '@manual_section', Regexp.last_match[1]
    k.instance_variable_set '@output_directory', "man#{k.instance_variable_get '@manual_section'}"
    #k.instance_variable_get('@state')[:footer] = "\\*(]D\\0\\0\\(em\\0\\0\\*(]W"
  end


  def init_ds
    super
    @state[:named_string].merge!({
      # tmac.an.new
      ']D' => 'Unix Programmer\'s Manual',  # default set by .TH
      ']W' => '7th Edition',                # default set by .TH
      #']W' => File.mtime(@source.filename).strftime("%B %d, %Y"),
      :footer => "\\*(]W"
    })
  end

  def init_tr
    super
    @state[:translate]['*'] = "\e(**"
  end

  # .so with absolute path, headers in /usr/include
  def req_so(name, breaking: nil)
    osdir = @source_dir.dup
    @source_dir << '/..'
    super(name)
    @source_dir = osdir
  end

  # tmac.an.new
  define_method 'AT' do |*args|
    req_ds(']W ' + case args[0]
                   when '4' then 'System III'
                   when '5' then "System V#{' Release ' + args[1] if args[1] and !args[1].empty?}"
                   else '7th Edition'
                   end
          )
  end

  define_method 'DE' do |*_args|
    req_fi
    send 'RE'
    req_sp('.5')
  end

  define_method 'DS' do |*_args|
    send 'RS'
    req_nf
    req_sp
  end

  define_method 'TH' do |*args|
    req_ds "]L #{args[2]}"
    req_ds "]W #{args[3]}" if args[3] and !args[3].strip.empty?
    req_ds "]D #{args[4]}" if args[4] and !args[4].strip.empty?

    heading = "#{args[0]}\\^(\\^#{args[1]}\\^)\\0\\0\\(em\\0\\0\\*(]D"
    @state[:named_string][:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @state[:named_string][']L'].empty?

    super(heading: heading)
  end

  # tmac.an.new
  define_method 'UC' do |v = nil, *_args|
    req_ds(']W ' + case v
                   when '4' then '4th Berkeley Distribution'
                   when '5' then '4.2 Berkeley Distribution'
                   when '6' then '4.3 Berkeley Distribution'
                   else '3rd Berkeley Distribution'
                   end
          )
  end

  define_method 'VE' do |*_args|
    warn ".VE can't yet draw margin characters (.mc)"
  end

  define_method 'VS' do |*_args|
    warn ".VS can't yet draw margin characters (.mc)"
  end

end
