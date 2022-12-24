# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 09/04/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Bell UNIX V6 Platform Overrides
#
#   from GL2-W2.5 lib/macros/an6
#   this ought to be interesting
#
# TODO
#   link detection - section in roman numerals
#

module UNIX_V6

  def self.extended(k)
    #k.define_singleton_method(:LP, k.method(:PP)) if k.methods.include?(:PP)
    k.define_singleton_method(:Bd, k.method(:req_bd)) if k.methods.include?(:req_bd)
    k.define_singleton_method(:Dt, k.method(:req_dt)) if k.methods.include?(:req_dt)
    k.define_singleton_method(:il, k.method(:req_it)) if k.methods.include?(:req_it)
    k.define_singleton_method(:dt, k.method(:DT)) if k.methods.include?(:DT)
    k.define_singleton_method(:sh, k.method(:SH)) if k.methods.include?(:SH)
    k.instance_eval "undef :req_bd"
    k.instance_eval "undef :req_dt"
    k.instance_eval "undef :req_it"
  end

  def init_ds
    super
    @state[:named_string].merge!({
      '_' => '_',
      '-' => '\\-',
      '|' => '\\|',
      "'" => '\\(aa',
      '>' => '\\(->',
      'a' => '\\(aa',
      'b' => '\\(*b',
      'g' => '\\(ga',
      'p' => '\\(*p',
      'r' => '\\(rg',
      'u' => '\\(*m',
      'v' => '\\(bv',
      'G' => '\\(*G',
      'X' => '\\(mu'
    })
  end

  def bd(*args)
    req_ft '3'
    if @register['V'] > 1
      parse "_#{args[0]}_"
    else
      parse "\\&#{args[0]}"
    end
    req_ft
  end

  def bn(*args)
    req_ft '3'
    if @register['V'] > 1
      parse "_#{args[0]}_\t\\&\\c"
    else
      parse "\\&#{args[0]}\t\\&\\c"
    end
    req_ft
  end

  def it(*args)
    # can't use req_ul as it calls req_it internally
    #req_ul
    req_ft '2'
    if @register['V'] > 1
      parse "_#{args[0]}_"
    else
      parse "\\&#{args[0]}"
    end
    # since we can't rely on .ul giving us a one-line input trap for .}f
    req_ft
  end

  def lp(*args)
    req_tc
    send 'i0'
    req_ta "#{args[1]}n"
    req_in "#{args[0]}n"
    req_ti "-#{args[1]}n"
  end

  define_method 's1' do |*args|
    req_sp '1v'
    #req_ne '2'
  end

  define_method 's2' do |*args|
    req_sp '.5v'
  end

  define_method 's3' do |*args|
    req_sp '.5v'
    #req_ne '2'
  end

  def th(*args)
    send 'TH', args[0], args[1], heading: "#{args[0]}\\|(\\|#{args[1]}\\|)\\0\\0\\*(em\\0\\0PWB/UNIX\\| #{args[2]}"
  end

end
