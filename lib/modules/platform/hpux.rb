# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 08/16/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# HPUX Platform Overrides
#

module HPUX

  def self.extended(k)
    k.instance_variable_set '@manual_entry',
      k.instance_variable_get('@input_filename').sub(/\.(\d\S?)$/, '')
    k.instance_variable_set '@manual_section', Regexp.last_match[1] if Regexp.last_match
  end

  def init_ds
    super
    @state[:named_string].merge!({
      #'Tm' => '&trade;',
      :footer => "\\*()H\\0\\0\\(em\\0\\0\\*(]W"
    })
  end

  def init_PD
    super
    @register['PD'] = @register[')P']         # HPUX .PD sets \n(PD instead of \n()P - the 10.20 OSF macros make extensive use of it
  end

  def init_nr
    @register[')t'] = Troff::Register.new(1)  # 8.5" x 11" format (notionally enable) - used in ascii(5)
    @register[')s'] = Troff::Register.new(0)  # 6" x 9" format (notionally disable)
  end

  def init_TH
    #super
    @register['IN'] = Troff::Register.new(@state[:base_indent])
  end

  define_method 'DT' do |*args|
    req_ta '3.6m 7.2m 10.8m 14.4m 18m 21.6m 28.8m 32.4m 36m 39.6m 43.2m 46.8m'
  end

  # index info - what even makes sense to do with this
  # probably nothing, as it seems to be for bound manuals (absolute page number)
  def iX(*args) ; end
  define_method 'IX' do |*args| ; end

  define_method 'PM' do |*args|
    warn ".PM #{args.inspect} - testing"
    pm = Block.new(text: Text.new(font: Font::B.new))
    pm.style.css[:text_align] = 'center'

    case args[0]
    when '', nil
      return '' # REVIEW I think that's how this goes. nothing => nothing. something, but different, default case
    when 'P'
      pm.text.text = [
        'PRIVATE', LineBreak.new,
        'This information should not be disclosed to unauthorized persons.', LineBreak.new,
        'It is meant solely for use by authorized Bell System employees.'
      ]
    when 'BP'
      pm.text.text = [
        'BELL LABORATORIES PROPRIETARY', LineBreak.new,
        'Not for use or disclosure outside Bell Laboratories except by', LineBreak.new,
        'written approval of the director of the distributing organization.'
      ]
    when 'BR'
      pm.text.text = [
        'BELL LABORATORIES RESTRICTED', LineBreak.new,
        'The information herein is meant solely for use by authorized', LineBreak.new,
        'Bell Laboratories employees and is not to be disclosed to others.'
      ]
    else
      pm.text.text = [
        'NOTICE', LineBreak.new,
        'Not for use or disclosure outside the', LineBreak.new,
        'Bell System except under written agreement.'
      ]
    end

    @document << pm
    @document << blockproto
  end
end
