# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# NEXTSTEP Platform Overrides
#
# TODO
#   db(3) wants to use the F font - what is it? ...appears to be a mistake.
#

module NEXTSTEP

  def self.extended(k)
    k.define_singleton_method(:LP, k.method(:PP)) if k.methods.include?(:PP)
    k.instance_variable_set '@manual_entry', k.instance_variable_get('@input_filename').sub(/\.(\d\S*)$/, '')
    k.instance_variable_set '@manual_section', Regexp.last_match[1] if Regexp.last_match
  end

  def init_ds
    super
    @state[:named_string].merge!(
      {
        #'Tm' => '&trade;',
        ']D' => 'UNIX Programmer\'s Manual',
        ']W' => '7th Edition',
        footer: "\\*(]W"
      }
    )
  end

  def init_tr
    super
    @state[:translate]['*'] = "\e(**"
  end

  def init_TH
    #super
    @register['IN'] = Troff::Register.new(@state[:base_indent])
  end

  define_method 'AT' do |*args|
    req_ds(']W ' + case args[0]
                   when '3' then '7th Edition'
                   when '4' then 'System III'
                   when '5'
                     case args[1]
                     when '' then 'System V'
                     else "System V Release #{args[1]}"
                     end
                   else '7th Edition'
                   end)
  end

  define_method 'DE' do |*_args|
    send 'RE'
    req_fi
    req_sp '.5'
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

    @state[:named_string][:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @state[:named_string][']L'].empty?
    heading = "#{args[0]}\\|(\\|#{args[1]}\\|)"
    heading << '\\0\\0\\(em\\0\\0\\*(]D'

    super(*args, heading: heading)
  end

  define_method 'UC' do |*args|
    req_ds(']W ' + case args[0]
                   when '3' then '3rd Berkeley Distribution'
                   when '4' then '4th Berkeley Distribution'
                   when '5' then '4.2 Berkeley Distribution'
                   when '6' then '4.3 Berkeley Distribution'
                   else '3rd Berkeley Distribution'
                   end)
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

module OPENSTEP
  def self.extended(k)
    k.extend ::NEXTSTEP
  end
end
