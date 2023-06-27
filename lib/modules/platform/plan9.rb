# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 09/10/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Plan9 Platform Overrides
#
# TODO
#   .fp 1 R LucidaSans
#   .fp 2 I LucidaSansI
#   .fp 3 B LucidaSansB
#   .fp 5 L LucidaCW
#   ...maybe see about making those actually use Lucida
#
#   grap(1) actually includes examples. is it reasonable to add support for this?
#   pic(1) as well!
#

class Font
  remove_const :L # name collision with "Geneva Light"
  class L < Font::C ; end
end

module Plan9

  def self.extended(k)
    k.define_singleton_method(:LP, k.method(:PP)) if k.methods.include?(:PP)
    k.define_singleton_method(:LP, k.method(:PP)) if k.methods.include?(:PP)
    case k.instance_variable_get '@input_filename'
    when 'INDEX', 'INDEX.html' # REVIEW have a look at the INDEX.html - minimum viable for us probably
      raise ManualIsBlacklisted, 'is nonsense'
    end
  end

  def init_ds
    super
    @state[:named_string].merge!(
      {
        'Tm' => '&trade;',
        ']D' => 'Plan 9',
        #']L' => '',
        ']W' => File.mtime(@source.filename).strftime("%B %d, %Y"),
        footer: "\\*(]D\\0\\0\\(em\\0\\0\\*(]W"
      }
    )
  end

  def init_fp
    super
    @state[:fonts][5] = 'L'
  end

  def init_tr
    super
    @state[:translate]['*'] = "\e(**"
  end

  def init_PD
    super
    @register['PD'] = @register[')P'] # Plan9 .PD sets \n(PD instead of \n()P - unknown if it is made use of
  end

  def init_TH
    #super
    @register['IN'] = Troff::Register.new(@state[:base_indent])
  end

  %w[B I L].each do |a|
    define_method a do |*args|
      fp = @state[:fonts].index (a=='B') ? 'L' : a # .B and .L both use \f5
      req_nh
      #req_it('1', '}N')
      req_it '1 }f'
      if args.any?
        parse "\\%\\&\\f#{fp}#{args[0]} #{args[1]} #{args[2]} #{args[3]} #{args[4]} #{args[5]}"
      else
        req_ft fp.to_s
      end
      send 'HY'
    end
  end

  %w[RI IR IB RB BR BI LR RL].each do |m|
    define_method m do |*args|
      (a,b) = m.scan(/./)
      fpa = @state[:fonts].index (a=='B') ? 'L' : a # .B and .L both use \f5
      fpb = @state[:fonts].index (b=='B') ? 'L' : b # .B and .L both use \f5
      req_nh
      parse %(.}S #{fpa} #{fpb} \\& "#{args[0]}" "#{args[1]}" "#{args[2]}" "#{args[3]}" "#{args[4]}" "#{args[5]}")
      send 'HY'
    end
  end

  # there's a pile of macros defined for doing two column text, which
  # seems like an arsepain for html. fortunately it doesn't look like any
  # are used in the online manual?
  # .2C, .1C, .C1, .C2, .C3
  # no proprietary markings (.PM, .)G) either, apparently

  define_method 'EE' do |*_args|
    req_ft '1'
    req_fi
  end

  define_method 'EX' do |*_args|
    req_ft '5'
    req_nf
  end

  define_method 'HY' do |*_args|
    req_hy '14'
  end

  define_method 'TF' do |*args|
    parse %(.IP "" "\\w'\f5#{args[0]}\\ \\ \\fP'u")
    send 'PD', '0'
  end

  define_method 'TH' do |*args|
    #req_ds "]L (\\^#{args[2]}\\^)" if args[2] and !args[2].strip.empty?
    req_ds "]L #{args[2]}" # I choose not to take tmac.an's parens
    req_ds "]D #{args[3]}" if args[3] and !args[3].strip.empty?

    heading = "#{args[0]}\\|(\\|#{args[1]}\\|)"
    heading << '\\0\\0\\(em\\0\\0\\*(]L' unless @state[:named_string][']L'].empty?

    super(*args, heading: heading)
  end

end
