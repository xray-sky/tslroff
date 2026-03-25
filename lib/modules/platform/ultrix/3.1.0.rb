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

class Ultrix::V3_1_0
  class Troff < Ultrix::Troff

    alias :HB :TB

    def init_ds
      super
      @named_strings.merge!(
        {
          ']D' => 'UNIX Programmer\'s Manual',
          ']W' => '7th Edition',
          :footer => "\\f(TB\\*(]T\\fP"
        }
      )
    end

    define_method 'CW' do |*_args|
      ft 'CW'
    end

    define_method 'De' do |*args|
      warn "REVIEW .De #{args.inspect}"
      ce '0'
      fi
    end

    define_method 'Ds' do |*args|
      warn "REVIEW .Ds #{args.inspect}"
      nf
      send "#{args[0]}D", "#{args[1]} #{args[0]}"
      ft 'R'
    end

    define_method 'EE' do |*_args|
      fi
      ps Font.defaultsize.to_s
      send 'in', "-#{@register['EX'].value}u"
      sp '.5'
      ft '1'
    end

    define_method 'EX' do |*args|
      nr "EX #{to_u "#{args[0] || 0}n+#{@state[:base_indent]}u"}"
      nf
      sp '.5'
      send 'in', "+#{@register['EX'].value}u"
      ft 'CW' # Geneva regular (changed to Constant Width for LN01)
      ps '-2'
      #vs '-2' # probably don't need this even once it's implemented; the browser will take care of it based on point size.
    end

    define_method 'Pn' do |*args|
      parse "#{args[0]}\\&\\f(CW\\|#{args[1]}\\|\\fP#{args[2]}"
    end

    define_method 'TH' do |*args|
      ds "]H #{args[0]}\\|(\\^#{args[1]}\\^)"
      ds "]W #{args[0]}\\|(\\^#{args[1]}\\^)"
      ds "]W #{args[0]}" unless args.count == 2

      heading = "\\*(]H" # tmac.an uses \f(TB
      # sets footer text according to \np set on cmdline - let's try to infer
      case args[1][0]
      when '1' then ds ']T "Commands'
      when '2' then ds ']T "System Calls'
      when '3' then ds ']T "Subroutines'
      when '4' then ds ']T "Special Files'
      when '5' then ds ']T "File Formats'
      when '6' then ds ']T "Games'
      when '7' then ds ']T "Macro Packags and Conventions'
      when '8' then ds ']T "Maintenance'
      end

      super(*args, heading: heading)
    end

  end
end
