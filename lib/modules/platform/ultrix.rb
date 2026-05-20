# frozen_string_literal: true
# encoding: UTF-8
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

module Ultrix

  # Triumvirate is essentially Helvetica
  class Font::TR < ::Font::H ; end
  class Font::TB < ::Font::HB ; end
  class Font::TI < ::Font::HI ; end

  class Troff < Troff::Man
    alias :LP :P

    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.([n\d][^.\s]*)$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      @related_info_heading ||= %r{SEE(?: |&nbsp;)+ALSO}i  # 3.x, 4.x
      super(source, **kwargs)
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          #'Tm' => '&trade;',
          footer: String.new('') # just a page number
        }
      )
    end

    def init_fp
      super
      # Geneva Light changed to Triumvirate Italic for LN01
      # Geneva Regular changed to Triumvirate Regular for LN01
      mount_font 4, 'BI'
      mount_font 5, 'CW' # from .CW '.nr SF 5'
      mount_font 8, 'HB' # Triumvirate Bold, from .TB '.nr SF 8'
    end

    def init_TH
      #super
      @register['IN'] = Troff::Register.new(@base_indent)
    end

    def CT(*args)
      parse "\\s-2<\\|CTRL\\|#{args[0]}\\|>\\s+2"
    end

    def CW(*_args)
      ft 'CW'
      nr 'SF', '5'
    end

    def EE(*_args)
      fi
      send 'in', '-.5i'
      sp '.5'
      ft '1'
    end

    def EX(*_args)
      nf
      sp '.5'
      send 'in', '+.5i'
      ft 'CW' # Geneva regular (changed to Constant Width for LN01)
    end

    def G(*args)
      ft 'H'
      if args.any?
        parse args.join(' ')
        send '}f'
      else
        it '1 }f'
      end
    end

    def GL(*args)
      ft 'L'
      if args.any?
        parse args.join(' ')
        send '}f'
      else
        it '1 }f'
      end
    end

    def I1(*args)
      warn "REVIEW .I1 #{args.inspect}"
      ti "+\\w'#{args[0]}'u"
    end

    def I2(*args)
      warn "REVIEW .I2 #{args.inspect}"
      sp '-1'
      ti "+\\w'#{args[0]}'u"
    end

    def MS(*args)
      parse "\\f(TR\\|#{args[0]}\\|\\fP\\fR(#{args[2]})\\fP#{args[2]}"
    end

    def NE(*_args)
      ce '0'
      send 'in', '-5n'
      sp '12p'
    end

    def NT(*args)
      ds 'NO NOTE'
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

    # appears to be for indexing purposes
    def NX(*_args) ; end

    def PN(*args)
      parse "\\f(TR\\|#{args[0]}\\|\\fP#{args[1]}"
    end

    def R(*_args)
      ft '1'
      nr 'SF 1'
    end

    def RN(*_args)
      parse "\\s-2<\\|RETURN\\|>\\s+2"
    end

    def TB(*args)
      warn "REVIEW .TB #{args.inspect}"
      @register['PF'] = @register['.f'].dup
      ft 'HB' # Triumvirate Bold
      if args.any?
        parse args.join(' ')
        send 'R'
      else
        nr 'SF 8'
      end
    end

    def VE(*args)
      # .if '\\$1'4' .mc \s12\(br\s0
      # draws a 12pt box rule as right margin character
      warn "can't yet .VE #{args.inspect}"
    end

    def VS(*args)
      # .mc
      # clears box rule margin character
      warn "can't yet .VS #{args.inspect}"
    end

  end

  def self.name_for_section(sec)
    case sec.downcase
    when '1'     then "<strong>#{sec}.</strong> Commands"
    when '1c'    then "<strong>#{sec}.</strong> Communication Commands"
    when '1g'    then "<strong>#{sec}.</strong> Graphics Commands"
    when '1int'  then "<strong>#{sec}.</strong> Internationalization Commands"
    when '1m'    then "<strong>#{sec}.</strong> Maintenance Commands"
    when '1mh'   then "<strong>#{sec}.</strong> RAND Message Handler Commands"
    when '1ncs'  then "<strong>#{sec}.</strong> Network Computing System Commands"
    when '1p'    then "<strong>#{sec}.</strong> Software Project Management System (SPMS) Commands"
    when '1sh5'  then "<strong>#{sec}.</strong> SVR2 Shell Commands"
    when '1x'    then "<strong>#{sec}.</strong> X11 Commands"
    when '1yp'   then "<strong>#{sec}.</strong> Yellow Pages (NIS) Commands"
    when '2'     then "<strong>#{sec}.</strong> System Calls"
    when '2nfs'  then "<strong>#{sec}.</strong> NFS Calls"
    when '2yp'   then "<strong>#{sec}.</strong> Yellow Pages (NIS) Calls"
    when '3'     then "<strong>#{sec}.</strong> Library Functions"
    when '3cur'  then "<strong>#{sec}.</strong> X/Open Curses Library"
    when '3dwt'  then "<strong>#{sec}.</strong> XUI Toolkit"
    when '3int'  then "<strong>#{sec}.</strong> International Suboutines"
    when '3krb'  then "<strong>#{sec}.</strong> Kerberos Library"
    when '3f'    then "<strong>#{sec}.</strong> FORTRAN Library"
    when '3m'    then "<strong>#{sec}.</strong> Math Library"
    when '3n'    then "<strong>#{sec}.</strong> Network Support Libraries"
    when '3ncs'  then "<strong>#{sec}.</strong> Network Computing System Library"
    when '3p'    then "<strong>#{sec}.</strong> Software Project Management System (SPMS) Routines"
    when '3s'    then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3thr'  then "<strong>#{sec}.</strong> pthreads Library"
    when '3x'    then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '3x11'  then "<strong>#{sec}.</strong> X11 Libraries"
    when '3xt'   then "<strong>#{sec}.</strong> X Toolkit"
    when '3xti'  then "<strong>#{sec}.</strong> X/Open Transport Interface"
    when '3yp'   then "<strong>#{sec}.</strong> Yellow Pages (NIS) Library"
    when '4'     then "<strong>#{sec}.</strong> Special Files"
    when '4f'    then "<strong>#{sec}.</strong> Network Protocol Families"
    when '4n'    then "<strong>#{sec}.</strong> Networking Facilities"
    when '4p'    then "<strong>#{sec}.</strong> Network Protocols"
    when '5'     then "<strong>#{sec}.</strong> File Formats"
    when '5x'    then "<strong>#{sec}.</strong> Motif File Formats"
    when '5cdfs' then "<strong>#{sec}.</strong> ISO 9660 Filesystem"
    when '5int'  then "<strong>#{sec}.</strong> International File Formats"
    when '5krb'  then "<strong>#{sec}.</strong> Kerberos File Formats"
    when '5mh'   then "<strong>#{sec}.</strong> RAND Message Handler File Formats"
    when '5nfs'  then "<strong>#{sec}.</strong> NFS File Formats"
    when '5n'    then "<strong>#{sec}.</strong> Networking File Formats"
    when '5yp'   then "<strong>#{sec}.</strong> Yellow Pages (NIS) File Formats"
    when '6'     then "<strong>#{sec}.</strong> Games and Demos"
    when '7'     then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '8'     then "<strong>#{sec}.</strong> Maintenance Procedures"
    when '8c'    then "<strong>#{sec}.</strong> Network Services"
    when '8cdfs' then "<strong>#{sec}.</strong> ISO 9660 Commands"
    when '8krb'  then "<strong>#{sec}.</strong> Kerberos Commands"
    when '8mh'   then "<strong>#{sec}.</strong> RAND Mail Handler Maintenance Commands"
    when '8n'    then "<strong>#{sec}.</strong> Network Services"
    when '8ncs'  then "<strong>#{sec}.</strong> Network Computing System Services"
    when '8nfs'  then "<strong>#{sec}.</strong> NFS Services"
    when '8ufs'  then "<strong>#{sec}.</strong> UFS Maintenance Commands"
    when '8v'    then "<strong>#{sec}.</strong> Maintenance Procedures"
    when '8x'    then "<strong>#{sec}.</strong> DECwindows Maintenance Tools"
    when '8yp'   then "<strong>#{sec}.</strong> Yellow Pages (NIS) Maintenance Commands"
    else "Section #{sec}"
    end
  end
end
