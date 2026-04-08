# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Ultrix 4.2.0 Platform Overrides
#
#   registers }W, }L, PO, ]C, ]T: defined to specify basic page
#   .UC and .AT defined in tmac.an.new
#
# TODO
#

module Ultrix
  module V4_2_0
    class Troff < Troff

      alias :HB :TB

      def init_ds
        super
        @named_strings.merge!(
          {
            ']D' => 'UNIX Programmer\'s Manual',
            ']W' => '7th Edition',
            :footer => "\\fH\\*(]W\\fP"
          }
        )
      end

      # .so with absolute path, osf/1 macros in /usr/share/lib/tmac
      # same sml/rsml v4.1.2.2 macros (used in 4.4 & 4.5 Motif pages) as OSF/1
      def so(name, breaking: nil)
        #name = "../../../..#{name}" if name.start_with?('/')
        case File.basename name
        when 'sml'  then extend OSF1::SML
        when 'rsml' then extend OSF1::RSML
        else super name, breaking: breaking
        end
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
        send 'in',  "-#{@register['EX'].value}u"
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

      # uses Courier fonts for 4.0
      def MS(*args)
        parse "\\&\\f(CW\\|#{args[0]}\\|\\fP\\fR(#{args[2]})\\fP#{args[2]}"
      end

      def NT(*args)
        ds 'NO Note' # <- this is the difference from base Ultrix ('NO NOTE') - actually still NOTE in 4.0
        ds "NO #{args[1]}" if args[1] and args[1] != 'C'
        ds "NO #{args[0]}" if args[0] and args[0] != 'C'
        sp '12p'
        send 'TB'
        ce
        parse "\\*(NO" # not unescape - need to trigger input trap
        sp '6p'
        ce '99' if args[0..1].include? 'C'
        send 'in', '+5n'
        # also bring in right margin by the same.
        # it'll work as long as there's only one paragraph worth of note
        @current_block.style.css[:margin_right] = @current_block.style.css[:margin_left]
        send 'R'
      end

      def Pn(*args)
        parse "#{args[0]}\\&\\f(CW\\|#{args[1]}\\|\\fP#{args[2]}"
      end

      # uses Courier fonts for 4.0
      def PN(*args)
        parse "\\&\\f(CW\\|#{args[0]}\\|\\fP#{args[1]}"
      end

      def R(*_args)
        ft 'R'
      end

      def TH(*args)
        ds "]L #{args[2]}"
        ds "]W #{args[3]}"
        ds "]D #{args[4]}"

        heading = "#{args[0]}\\|(\\^#{args[1]}\\^)".+@ # tmac.an uses \f(HB
        heading << '\\0\\0\\(em\\0\\0\\*(]L' unless @named_strings[']L'].empty? # tmac.an uses \fH
        # this would go below the top .tl if given, toward the spine. I think I'll put it in <h1> instead.
        heading << '\\0\\0\\(em\\0\\0\\*(]D' unless @named_strings[']D'].empty? # tmac.an uses \f(HB

        super(*args, heading: heading)
      end

    end
  end
end

# all the same tmac.an
# 4.0 still has NO NOTE in .NT, a couple of indent changes for nroff, and slightly
#     different page numbering in the footer, but we don't care. otherwise identical.
Ultrix::V4_0_0_mips = Ultrix::V4_2_0
Ultrix::V4_0_0_VAX  = Ultrix::V4_2_0
Ultrix::V4_1_0_mips = Ultrix::V4_2_0
Ultrix::V4_1_0_VAX  = Ultrix::V4_2_0
Ultrix::V4_2_0_mips = Ultrix::V4_2_0
Ultrix::V4_2_0_VAX  = Ultrix::V4_2_0
Ultrix::V4_4_0_mips = Ultrix::V4_2_0
Ultrix::V4_4_0_VAX  = Ultrix::V4_2_0
Ultrix::V4_5_1_mips = Ultrix::V4_2_0
Ultrix::V4_5_1_VAX  = Ultrix::V4_2_0


