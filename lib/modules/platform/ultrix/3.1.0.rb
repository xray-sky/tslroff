# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/16/23.
# Copyright 2023 Typewritten Software. All rights reserved.
#
#
# Ultrix 3.1.0 Platform Overrides
#
#   note - defines \n(PL as 9i (page length) and IN .25i
#
# TODO
#

module Ultrix_3_1_0

  def self.extended(k)
    k.define_singleton_method(:req_HB, k.method(:req_TB)) if k.methods.include? :req_TB
    k.instance_variable_set '@related_info_heading', %r{SEE(?: |&nbsp;)+ALSO}i
    case k.instance_variable_get '@input_filename'
    when 'VAX-RISC_tcpdump_patch'
      raise ManualIsBlacklisted, 'not a manual entry - all nulls'
    end
  end

  def init_ds
    super
    @state[:named_string].merge!(
      {
        ']D' => 'UNIX Programmer\'s Manual',
        ']W' => '7th Edition',
        :footer => "\\f(TB\\*(]T\\fP"
      }
    )
  end

  define_method 'CW' do |*_args|
    req_ft 'CW'
  end

  define_method 'De' do |*args|
    warn "REVIEW .De #{args.inspect}"
    req_ce '0'
    req_fi
  end

  define_method 'Ds' do |*args|
    warn "REVIEW .Ds #{args.inspect}"
    req_nf
    send "#{args[0]}D", "#{args[1]} #{args[0]}"
    req_ft 'R'
  end

  define_method 'EE' do |*_args|
    req_fi
    req_ps Font.defaultsize.to_s
    req_in "-#{@register['EX'].value}u"
    req_sp '.5'
    req_ft '1'
  end

  define_method 'EX' do |*args|
    req_nr "EX #{to_u "#{args[0] || 0}n+#{@state[:base_indent]}u"}"
    req_nf
    req_sp '.5'
    req_in "+#{@register['EX'].value}u"
    req_ft 'CW' # Geneva regular (changed to Constant Width for LN01)
    req_ps '-2'
    #req_vs '-2' # probably don't need this even once it's implemented; the browser will take care of it based on point size.
  end

  define_method 'Pn' do |*args|
    parse "#{args[0]}\\&\\f(CW\\|#{args[1]}\\|\\fP#{args[2]}"
  end

  define_method 'TH' do |*args|
    req_ds "]H #{args[0]}\\|(\\^#{args[1]}\\^)"
    req_ds "]W #{args[0]}\\|(\\^#{args[1]}\\^)"
    req_ds "]W #{args[0]}" unless args.count == 2

    heading = "\\*(]H" # tmac.an uses \f(TB
    # sets footer text according to \np set on cmdline - let's try to infer
    case args[1][0]
    when '1' then req_ds ']T "Commands'
    when '2' then req_ds ']T "System Calls'
    when '3' then req_ds ']T "Subroutines'
    when '4' then req_ds ']T "Special Files'
    when '5' then req_ds ']T "File Formats'
    when '6' then req_ds ']T "Games'
    when '7' then req_ds ']T "Macro Packags and Conventions'
    when '8' then req_ds ']T "Maintenance'
    end

    super(*args, heading: heading)
  end

end
