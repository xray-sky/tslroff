# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/12/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# NEWS-os Platform Overrides
#
# TODO
#   several of the MH pages want to use the T, M, and X fonts (what are they)
#

module NEWS_os

  def self.extended(k)
    k.define_singleton_method(:LP, k.method(:PP)) if k.methods.include?(:PP)
    k.instance_variable_set '@manual_entry', k.instance_variable_get('@input_filename').sub(/\.([\dnop][^.]*)$/, '')
    k.instance_variable_set '@manual_section', Regexp.last_match[1] if Regexp.last_match
  end

  def init_tr
    super
    @state[:translate]['*'] = "\e(**"
  end

  def init_TH
    #super
    @register['IN'] = Troff::Register.new(@state[:base_indent])
  end

  # doesn't matter, ]W not used in header or footer
  define_method 'AT' do |*args|
    req_ds ']W ' + case args[0]
                   when '3' then '7th Edition'
                   when '4' then 'System III'
                   when '5'
                     if args[1] and !args[1].empty?
                       "System V Release #{args[1]}"
                     else
                       'System V'
                     end
                   else '7th Edition'
                   end
  end

  # index info - what even makes sense to do with this
  # probably nothing, as it seems to be for bound manuals (absolute page number)
  def iX(*_args) ; end
  define_method 'IX' do |*_args| ; end

  define_method 'TH' do |*args|
    req_ds "]L #{args[2]}"
    req_ds "]W #{args[3]}" if args[3] and !args[3].strip.empty?
    req_ds "]D #{args[4]}" if args[4] and !args[4].strip.empty?

    heading = "#{args[0]}\\|(\\|#{args[1]}\\|)"
    heading << '\\0\\0\\(em\\0\\0\\*(]D' unless @state[:named_string][']D'].empty?

    super(*args, heading: heading)
  end

  # doesn't matter, ]W not used in header or footer
  define_method 'UC' do |*args|
    req_ds ']W ' + case args[0]
                   when '3' then '3rd Berkeley Distribution'
                   when '4' then '4th Berkeley Distribution'
                   when '5' then '4.2 Berkeley Distribution'
                   when '6' then '4.3 Berkeley Distribution'
                   else '3rd Berkeley Distribution'
                   end
  end

  # good news - margin characters don't seem to be used anywhere in the Sony manual
  def req_VE(*args)
    # .if '\\$1'4' .mc \s12\(br\s0
    # draws a 12pt box rule as right margin character
    warn "can't yet .VE #{args.inspect}"
  end

  def req_VS(*args)
    # .mc
    # clears box rule margin character
    warn "can't yet .VS #{args.inspect}"
  end
end


