# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Ultrix Platform Overrides
#
# TODO
#   PL (page length) and SF (save font) registers
#

class Font # Triumvirate is essentially Helvetica
  class TR < Font::H ; end
  class TB < Font::HB ; end
  class TI < Font::HI ; end
end

module Ultrix

  def self.extended(k)
    k.define_singleton_method(:LP, k.method(:PP)) if k.methods.include?(:PP)
    k.instance_variable_set '@manual_entry',
      k.instance_variable_get('@input_filename').sub(/\.([n\d][^.\s]*)$/, '')
    k.instance_variable_set '@manual_section', Regexp.last_match[1] if Regexp.last_match
    case k.instance_variable_get '@input_filename'
    when /^default\./
      k.instance_variable_set '@manual_entry', '_default'
    when /^index\./
      k.instance_variable_set '@manual_entry', '_index'
    end
  end

  def init_ds
    super
    @state[:named_string].merge!({
      #'Tm' => '&trade;',
      :footer => '' # just a page number
    })
  end

  def init_fp
    super
    # Geneva Light changed to Triumvirate Italic for LN01
    # Geneva Regular changed to Triumvirate Regular for LN01
    @state[:fonts][4] = 'BI'
    @state[:fonts][5] = 'CW' # from .CW '.nr SF 5'
    @state[:fonts][8] = 'HB' # Triumvirate Bold, from .TB '.nr SF 8'
  end

  def init_TH
    #super
    @register['IN'] = Troff::Register.new(@state[:base_indent])
  end

  define_method 'CT' do |*args|
    parse "\\s-2<\\|CTRL\\|#{args[0]}\\|>\\s+2"
  end

  define_method 'CW' do |*args|
    req_ft 'CW'
    req_nr 'SF', '5'
  end

  define_method 'EE' do |*args|
    req_fi
    req_in '-.5i'
    req_sp '.5'
    req_ft '1'
  end

  define_method 'EX' do |*args|
    req_nf
    req_sp '.5'
    req_in '+.5i'
    req_ft 'CW' # Geneva regular (changed to Constant Width for LN01)
  end

  define_method 'G' do |*args|
    req_ft 'H'
    if args.any?
      parse args.join(' ')
      send '}f'
    else
      req_it '1 }f'
    end
  end

  define_method 'GL' do |*args|
    req_ft 'L'
    if args.any?
      parse args.join(' ')
      send '}f'
    else
      req_it '1 }f'
    end
  end

  define_method 'I1' do |*args|
    warn "REVIEW .I1 #{args.inspect}"
    req_ti "+\\w'#{args[0]}'u"
  end

  define_method 'I2' do |*args|
    warn "REVIEW .I2 #{args.inspect}"
    req_sp '-1'
    req_ti "+\\w'#{args[0]}'u"
  end

  define_method 'MS' do |*args|
    parse "\\f(TR\\|#{args[0]}\\|\\fP\\fR(#{args[2]})\\fP#{args[2]}"
  end

  define_method 'NE' do |*args|
    req_ce '0'
    req_in '-5n'
    req_sp '12p'
  end

  define_method 'NT' do |*args|
    req_ds 'NO NOTE'
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

  # appears to be for indexing purposes
  define_method 'NX' do |*args| ; end

  define_method 'PN' do |*args|
    parse "\\f(TR\\|#{args[0]}\\|\\fP#{args[1]}"
  end

  define_method 'R' do |*args|
    req_ft '1'
    req_nr 'SF 1'
  end

  define_method 'RN' do |*args|
    parse "\\s-2<\\|RETURN\\|>\\s+2"
  end

  define_method 'TB' do |*args|
    warn "REVIEW .TB #{args.inspect}"
    @register['PF'] = @register['.f'].dup
    req_ft 'HB' # Triumvirate Bold
    if args.any?
      parse args.join(' ')
      send 'R'
    else
      req_nr 'SF 8'
    end
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
