# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 08/12/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# NEWS-os Platform Overrides
#
# TODO
#

module NEWS_os

  def self.extended(k)
    k.define_singleton_method(:req_LP, k.method(:req_PP)) if k.methods.include?(:req_PP)
    k.instance_variable_set '@manual_entry',
      k.instance_variable_get('@input_filename').sub(/\.([\dnop][^\.]*)$/, '')
    k.instance_variable_set '@manual_section', Regexp.last_match[1] if Regexp.last_match
  end

  def init_ds
    super
    @state[:named_string].merge!({
      'R'  => '&reg;',
      'S'  => "\\s#{Font.defaultsize}",
      #'Tm' => '&trade;',
      'lq' => '&ldquo;',
      'rq' => '&rdquo;',
    })
  end

  def init_tr
    super
    @state[:translate]['*'] = "\e(**"
  end

  def init_TH
    #super
    @register['IN'] = Troff::Register.new(@state[:base_indent])
  end

  # .so with absolute path, headers in /usr/include
  #def req_so(name)
  #  osdir = @source_dir.dup
  #  @source_dir << '/../..' if name.start_with?('/')
  #  super(name)
  #  @source_dir = osdir
  #end

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


