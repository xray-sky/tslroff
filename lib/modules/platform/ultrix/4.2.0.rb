# encoding: US-ASCII
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

module Ultrix_4_2_0

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
    @state[:named_string].merge!({
      ']D' => 'UNIX Programmer\'s Manual',
      ']W' => '7th Edition',
      :footer => "\\fH\\*(]W\\fP"
    })
  end

  define_method 'CW' do |*args|
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

  define_method 'EE' do |*args|
    req_fi
    req_ps "#{Font.defaultsize}"
    req_in "-#{@register['EX'].value}u"
    req_sp '.5'
    req_ft '1'
  end

  define_method 'EX' do |*args|
    req_nr 'EX ' + to_u("#{args[0] || 0}n+#{@state[:base_indent]}u")
    req_nf
    req_sp '.5'
    req_in "+#{@register['EX'].value}u"
    req_ft 'CW' # Geneva regular (changed to Constant Width for LN01)
    req_ps '-2'
    #req_vs '-2' # probably don't need this even once it's implemented; the browser will take care of it based on point size.
  end

  # uses Courier fonts for 4.0
  define_method 'MS' do |*args|
    parse "\\&\\f(CW\\|#{args[0]}\\|\\fP\\fR(#{args[2]})\\fP#{args[2]}"
  end

  define_method 'NT' do |*args|
    req_ds 'NO Note' # <- this is the difference from base Ultrix ('NO NOTE')
    req_ds "NO #{args[1]}" if args[1] and args[1] != 'C'
    req_ds "NO #{args[0]}" if args[0] and args[0] != 'C'
    req_sp '12p'
    send 'TB'
    req_ce
    parse "\\*(NO" # not unescape - need to trigger input trap
    req_sp '6p'
    req_ce '99' if args[0..1].include? 'C'
    req_in '+5n'
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

  define_method 'R' do |*args|
    req_ft 'R'
  end

  define_method 'TH' do |*args|
    req_ds "]L #{args[2]}"
    req_ds "]W #{args[3]}"
    req_ds "]D #{args[4]}"

    heading = "#{args[0]}\\|(\\^#{args[1]}\\^)" # tmac.an uses \f(HB
    heading << '\\0\\0\\(em\\0\\0\\*(]L' unless @state[:named_string][']L'].empty? # tmac.an uses \fH
    # this would go below the top .tl if given, toward the spine. I think I'll put it in <h1> instead.
    heading << '\\0\\0\\(em\\0\\0\\*(]D'  unless @state[:named_string][']D'].empty? # tmac.an uses \f(HB

    super(*args, heading: heading)
  end

end

# all the same tmac.an

module Ultrix_4_2_0_mips
  def self.extended(k)
    k.extend Ultrix_4_2_0
  end
end

module Ultrix_4_2_0_VAX
  def self.extended(k)
    k.extend Ultrix_4_2_0
  end
end

module Ultrix_4_5_1_mips
  def self.extended(k)
    k.extend Ultrix_4_2_0
  end
end

module Ultrix_4_5_1_VAX
  def self.extended(k)
    k.extend Ultrix_4_5_1
  end
end


