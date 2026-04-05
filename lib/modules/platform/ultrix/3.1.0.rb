# encoding: UTF-8
#
# frozen_string_literal: true
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

module Ultrix
  module V3_1_0
    class Troff < Troff

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

      def CW(*_args)
        ft 'CW'
      end

      def De(*args)
        warn "REVIEW .De #{args.inspect}"
        ce '0'
        fi
      end

      def Ds(*args)
        warn "REVIEW .Ds #{args.inspect}"
        nf
        send "#{args[0]}D", "#{args[1]} #{args[0]}"
        ft 'R'
      end

      def EE(*_args)
        fi
        ps Font.defaultsize.to_s
        send 'in', "-#{@register['EX'].value}u"
        sp '.5'
        ft '1'
      end

      def EX(*args)
        nr "EX #{to_u "#{args[0] || 0}n+#{@state[:base_indent]}u"}"
        nf
        sp '.5'
        send 'in', "+#{@register['EX'].value}u"
        ft 'CW' # Geneva regular (changed to Constant Width for LN01)
        ps '-2'
        #vs '-2' # probably don't need this even once it's implemented; the browser will take care of it based on point size.
      end

      def Pn(*args)
        parse "#{args[0]}\\&\\f(CW\\|#{args[1]}\\|\\fP#{args[2]}"
      end

      def TH(*args)
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
end
