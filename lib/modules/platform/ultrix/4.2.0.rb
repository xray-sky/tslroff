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

class Ultrix::V4_2_0
  class Troff < ::Ultrix::Troff

    alias :HB :TB

    def initialize(source)
      @related_info_heading ||= %r{SEE(?: |&nbsp;)+ALSO}i
      case source.file
      when 'VAX-RISC_tcpdump_patch'
        raise ManualIsBlacklisted, 'not a manual entry - all nulls'
      end
      super(source)
    end

    def init_ds
      super
      @state[:named_string].merge!(
        {
          ']D' => 'UNIX Programmer\'s Manual',
          ']W' => '7th Edition',
          :footer => "\\fH\\*(]W\\fP"
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
      send 'in',  "-#{@register['EX'].value}u"
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

    # uses Courier fonts for 4.0
    define_method 'MS' do |*args|
      parse "\\&\\f(CW\\|#{args[0]}\\|\\fP\\fR(#{args[2]})\\fP#{args[2]}"
    end

    define_method 'NT' do |*args|
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

    define_method 'Pn' do |*args|
      parse "#{args[0]}\\&\\f(CW\\|#{args[1]}\\|\\fP#{args[2]}"
    end

    # uses Courier fonts for 4.0
    define_method 'PN' do |*args|
      parse "\\&\\f(CW\\|#{args[0]}\\|\\fP#{args[1]}"
    end

    define_method 'R' do |*_args|
      ft 'R'
    end

    define_method 'TH' do |*args|
      ds "]L #{args[2]}"
      ds "]W #{args[3]}"
      ds "]D #{args[4]}"

      heading = "#{args[0]}\\|(\\^#{args[1]}\\^)" # tmac.an uses \f(HB
      heading << '\\0\\0\\(em\\0\\0\\*(]L' unless @state[:named_string][']L'].empty? # tmac.an uses \fH
      # this would go below the top .tl if given, toward the spine. I think I'll put it in <h1> instead.
      heading << '\\0\\0\\(em\\0\\0\\*(]D' unless @state[:named_string][']D'].empty? # tmac.an uses \f(HB

      super(*args, heading: heading)
    end

  end
end

# all the same tmac.an
# 4.0 still has NO NOTE in .NT, a couple of indent changes for nroff, and slightly
#     different page numbering in the footer, but we don't care. otherwise identical.

class Ultrix::V4_0_0_mips < ::Ultrix::V4_2_0 ; end
class Ultrix::V4_0_0_VAX  < ::Ultrix::V4_2_0 ; end
class Ultrix::V4_1_0_mips < ::Ultrix::V4_2_0 ; end
class Ultrix::V4_1_0_VAX  < ::Ultrix::V4_2_0 ; end
class Ultrix::V4_2_0_mips < ::Ultrix::V4_2_0 ; end
class Ultrix::V4_2_0_VAX  < ::Ultrix::V4_2_0 ; end
class Ultrix::V4_4_0_mips < ::Ultrix::V4_2_0 ; end
class Ultrix::V4_4_0_VAX  < ::Ultrix::V4_2_0 ; end
class Ultrix::V4_5_1_mips < ::Ultrix::V4_2_0 ; end
class Ultrix::V4_5_1_VAX  < ::Ultrix::V4_2_0 ; end


