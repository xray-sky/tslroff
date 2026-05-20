# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/16/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# HPUX Platform Overrides
#

module HPUX
  class Troff < Troff::Man

    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.(\d\S?)$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      super(source, **kwargs)
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          footer: "\\*()H\\0\\0\\(em\\0\\0\\*(]W".+@
          #'Tm' => '&trade;',
        }
      )
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
      @register['IN'] = Troff::Register.new(@base_indent)
    end

    def DT(*_args)
      ta '3.6m 7.2m 10.8m 14.4m 18m 21.6m 28.8m 32.4m 36m 39.6m 43.2m 46.8m'
    end

    # index info - what even makes sense to do with this
    # probably nothing, as it seems to be for bound manuals (absolute page number)
    def iX(*_args) ; end
    def IX(*_args) ; end

    def PM(*args)
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

  def self.name_for_section(sec)
    case sec.downcase
    when '0'     then "<strong>#{sec}.</strong> Preface"
    when '1'     then "<strong>#{sec}.</strong> Commands"
    when '1c++'  then "<strong>#{sec}.</strong> C++ Programming Commands"
    when '1g'    then "<strong>#{sec}.</strong> Graphics Commands"
    when '1m'    then "<strong>#{sec}.</strong> Maintenance Commands"
    when '1x'    then "<strong>#{sec}.</strong> Vue Commands"
    when '1x11'  then "<strong>#{sec}.</strong> X11 Commands"
    when '2'     then "<strong>#{sec}.</strong> System Calls"
    when '2v'    then "<strong>#{sec}.</strong> SVID System Calls"
    when '3'     then "<strong>#{sec}.</strong> Subroutines and Libraries"
    when '3c'    then "<strong>#{sec}.</strong> C Library"
    when '3c++'  then "<strong>#{sec}.</strong> C++ Libraries"
    when '3d'    then "<strong>#{sec}.</strong> Instrument Support Library" # HP-UX 5.00
    when '3f'    then "<strong>#{sec}.</strong> FORTRAN Library"
    when '3g'    then "<strong>#{sec}.</strong> Graphics Library"
    when '3i'    then "<strong>#{sec}.</strong> Instrument Support Library"
    when '3m'    then "<strong>#{sec}.</strong> Math Library"
    when '3n'    then "<strong>#{sec}.</strong> Network Support Libraries"
    when '3r'    then "<strong>#{sec}.</strong> RPC Functions"
    when '3s'    then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3w'    then "<strong>#{sec}.</strong> HP Windows Routines"
    when '3x'    then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '3x11'  then "<strong>#{sec}.</strong> X11 Library"
    when '4'     then "<strong>#{sec}.</strong> File Formats"
    when '4g'    then "<strong>#{sec}.</strong> Graphics File Formats"
    when '4x'    then "<strong>#{sec}.</strong> Vue File Formats"
    when '5'     then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '5x'    then "<strong>#{sec}.</strong> Vue Miscellaneous Facilities"
    when '6'     then "<strong>#{sec}.</strong> Networking Facilities"
    when '7'     then "<strong>#{sec}.</strong> Device Special Files"
    when '7f'    then "<strong>#{sec}.</strong> Protocol Families"
    when '7p'    then "<strong>#{sec}.</strong> Network Protocols"
    when '8'     then "<strong>#{sec}.</strong> Maintenance Procedures"
    when '8sdce' then "<strong>#{sec}.</strong> DCE Maintenance Procedures"
    when '9'     then "<strong>#{sec}.</strong> Glossary"
    else "Section #{sec}"
    end
  end
end
