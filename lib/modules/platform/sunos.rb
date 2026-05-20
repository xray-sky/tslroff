# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 05/10/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# SunOS Platform Overrides
#
# TODO
# √ font 'L' is used; /usr/lib/font/fontlist has it as "geneva light"
#    - separate from G ("geneva regular") so: helvetica light

module SunOS
  class Nroff < Nroff ; end
  class Troff < Troff::Man
    alias :LP :P

    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.(\d\S{0,2})$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      super(source, **kwargs)
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          #'Tm' => '&trade;',
          footer: String.new('\\*(]W')
        }
      )
    end

    def init_tr
      super
      @character_translations['*'] = "\e(**"
    end

    def init_TH
      #super
      @register['IN'] = Troff::Register.new(@base_indent)
    end

    # .so with absolute path, headers in /usr/include
    def so(name, breaking: nil, basedir: nil)
      basedir = "#{@source.dir}#{"/../.." if name.start_with?('/')}"
      super(name, breaking: breaking, basedir: basedir)
    end

    # index info - what even makes sense to do with this
    # probably nothing, as it seems to be for bound manuals (absolute page number)
    def IX(*_args) ; end

    # some pages call this, but the def is commented out all the way back to 0.3
    # defining it as a no-op suppresses the warning.
    def UC(*_args) ; end

    # good news - margin characters don't seem to be used anywhere in the Sun manual
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

    module Macros
      module OpenWindows
        def self.extended(k)
          k.send :nr, '"o 1' # prevent multiple inclusion
          k.send :nr, 'Ji 16'
        end

        # redefines .R, .B, .I, plus .L and .LB
        def B(*args)
          nr "PQ #{@register['.f']}"
          ft '3'
          parse "\\&\\f#{@register['PQ']}#{args[2]}\\fI#{args[0]}\\f#{@register['PQ']}#{args[1]}" if args[0] and !args[0].empty?
        end

        def I(*args)
          nr "PQ #{@register['.f']}"
          ft '2'
          parse "\\&\\f#{@register['PQ']}#{args[2]}\\fI#{args[0]}\\|\\f#{@register['PQ']}#{args[1]}" if args[0] and !args[0].empty?
        end

        def L(*args) # REVIEW "listing font"
          nr "PQ #{@register['.f']}"
          parse "\\&\\f#{@register['PQ']}#{args[2]}\\fL#{args[0]}\\f#{@register['PQ']}#{args[1]}" if args[0] and !args[0].empty?
        end

        def LB(*args) # REVIEW "bold listing font"
          nr "PQ #{@register['.f']}"
          parse "\\&\\f#{@register['PQ']}#{args[2]}\\fLB#{args[0]}\\f#{@register['PQ']}#{args[1]}" if args[0] and !args[0].empty?
        end

        def Jo(*args)
          #mk jo
          parse "\\ #{args[0]}\\h'2.0i-\\w'#{args[0]}'u'#{args[1]}\\h'1.5i-\\w'#{args[1]}'u'#{args[2]}\\h'1.5i-\\w'#{args[2]}'u'#{args[3]}"
          ###
          ### TODO box
          ###
          #sp '-.5'
          #nf
          #parse "\\h'-.5n'\\L'|#{@register['jo']}u-1'\\l'#{@register['.l']}u-1.25i+1n\\(ul'\\L'-|#{@register['jo']}u+1'\\l'|0u-.5n\\(ul"
          #fi
        end

        # 5.1 gives two consecutive non-equivalent defs for .Jp - this is the second
        def Jp(*args)
          #mk jq
          parse " \\fIclass\\fP:\\0\\&\\fL\\#{args[0]}\\fP\\h'1.5i-\\w'\\fL#{args[0]}\\fP'u'\\fItype\\fP:\\0\\&\\fL#{args[1]}\\fP\\h'1.25i-\\w'\\fL#{args[1]}\\fP'u'\\fIdefault\\fP:\\0\\&\\fL#{args[2]}\\fP\\h'1.0i-w'\\fL#{args[2]}\\fP'u'\\h'|5i'\\fIaccess\\fP:\\0\\&\\fL#{args[3]}\\fP\\h'1.0i-\w'\\fL#{args[3]}\\fP'u'"
          ###
          ### TODO box
          ###
          #sp '-.5'
          #nf
          #parse "\\h'-.5n'\\L'|#{@register['jq']}u-1'\\l'#{@register['.l']}u-1.25i+1n\\(ul'\\L'-|#{@register['jq']}u+1'\\l'|0u-.5n\\(ul"
          #fi
        end

        def Jq(*args)
          nr "jw \w'\\fL#{args[0]}\\fP'"
          nr "jw #{@register['jw']}+\w'\\fL#{args[1]}\\fP'"
          nr "jw #{@register['jw']}+\w'\\fL#{args[2]}\\fP'"
          br
          #mk 'jq'
          if @register['jw'] > 1300
            parse "\\ \\fIclass\\fP:\\|\\&\\fL#{args[0]}\\0\\fItype\\fP:\\|\\&\\fL#{args[1]}\\0\\fIdefault\\fP:\\|\\&\\fL#{args[2]}\\fP\\h'|4.9i'\\fIaccess\\fP:\\|\\|\\&\\fL#{args[3]}\\fP\\h'0.8i-\\w'\\fL#{args[3]}\\fP'u'"
          else
            parse "\\ \\fIclass\\fP:\\|\\&\\fL#{args[0]}\\fP\\h'1.5i-\\w'\\fL#{args[0]}\\fP'u'\\fItype\\fP:\\|\\&\\fL#{args[1]}\\fP\\h'1.25i-\\w'\\fL#{args[1]}\\fP'u'\\fIdefault\\fP:\\|\\&\\fL#{args[2]}\\fP\\h'1.0i-\\2'\\fL#{args[2]}\\fP'u'\\h'|5i'\\fIaccess\\fP:\\|\\&\\fL#{args[3]}\\fP\\h'0.8i-\\2'\\fL#{args[3]}\\fP'u'"
          end
          ###
          ### TODO box
          ###
          #sp '-.5'
          #nf
          #parse "\\h'-.5n'\\L'|#{@register['jq']}u-1'\\l'#{@register['.l']}u-1.25i+1n\\(ul'\\L'-|#{@register['jq']}u+1'\\l'|0u-.5n\\(ul"
          #sp '-1'
          #fi
        end

        def JF(*args)
          nr "Jf \\w'#{@named_strings['Jf']}'"
          nr "Jf \\w'#{args[2]}'" if args[2] and !args[2].empty?
          parse "#{args[0]} \\h'.25i+#{@register['Jf']}u-\\w'#{args[0]}'u'#{args[1]}"
          br
        end

        def Lx(*args)
          parse %(.L "#{args[0]}" "#{args[1]}" "#{args[2]}")
          #.IX "\\$1" "" "\fL\\$1\f1"
        end

        def Ix(*args)
          parse %(.I "#{args[0]}" "#{args[1]}" "#{args[2]}")
          #.IX "\\$1" "" "\fL\\$1\f1"
        end

        def Bx(*args)
          parse %(.B "#{args[0]}" "#{args[1]}" "#{args[2]}")
          #.IX "\\$1" "" "\fL\\$1\f1"
        end

        def Jx(*args)
          parse %(.Lx "#{args[0]}" "#{args[1]}" "#{args[2]}")
        end

        alias :JX :Jx

        def JL(*args)
          if args.empty?
            ft 'L'
          else
            parse %(.L "#{args[0]}" "#{args[1]}" "#{args[2]}")
          end
        end

        def JR(*_args)
          ft '1'
        end

        def JS(*_args)
          parse '.JL'
          nf
        end

        def JE(*_args)
          parse '.JR'
          fi
        end

        def TF(*args)
          nr "TF #{@register['.f']}"
          nr "TX #{@register['.s']}"
          nr 'PL 3'
          # two pointless conditions involving \n(PL=1 or 2 elided
          #ta '2iR 2.25i' # is this a right justified tab? or just an error
          ta '2i 2.25i'
          ti '0'
          parse "\t\\&\\s11\\0\\0#{@named_strings['tS']}\t\\fI\\&#{args[0]}\\f#{@register['TF']}\\s#{@register['TX']}"
        end

        def TN(*args)
          nr 'T1 +1'
          ll "#{@register['LL']}u"
          ds "tH #{args[0]}"
          ds "tS Table #{@register['T1']}"
          if @register['IK'] <= 0
            sp '1v' if @register['nl'] > @register['L#'].value # careful comparing Registers
            sp "|@#{register['B#']}u+2v" if @register['B#'] > 0 and @register['B#'] >= @register['nl'].value
            nr 'B# 0'
          else
            sp '1v'
            if @register['K#'] > 0
              sp "|#{@register['K#']}u+2v"
              nr 'K# 0'
            else
              sp "(#{@register['B#']}u-#{@register['nl']}u+1v)u" if @register['B#'] >= @register['nl'].value
              nr 'B# 0'
            end
          end
          ne '2i'
          parse %(.TF "#{@named_strings['tH']}")
          #.if \\nF .if \\n(IK \!.tm .CE F 1 "\\$1" \\\\n% \\n(H1 \\n(T1
          #.if \\nF .if !\\n(IK .tm .CE F 1 "\\$1" \\n% \\n(H1 \\n(T1
        end

        def TC(*_args) ; end # table continued on next page - who cares

        def FN(*args)
          nr 'F1 +1'
          ll "#{@register['LL']}u"
          ds "tS Figure #{@register['F1']}"
          sp '1v'
          parse %(.TF "#{args[0]}")
          #.if \\nF .if \\n(IK \!.tm .CE F 1 "\\$1" \\\\n% \\n(H1 \\n(F1
          #.if \\nF .if !\\n(IK .tm .CE F 1 "\\$1" \\n% \\n(H1 \\n(F1
        end

        def TH(*args)
          parse '.PD'
          parse '.DT'
          nr 'F1 0'
          ll '7i'
          nr "LL #{@register['.l']}"
          ds "]H #{args[0]}\\|(\\|#{args[1]}\\|)"
          ds ']D Misc. Reference Manual Pages'
          ds ']D OPEN LOOK Widgets' if args[1] == '3W'
          ds "]W #{args[3]}" if args[3] and !args[3].empty?
          #ds "]D #{args[4]}" if args[4] and !args[4].empty? # pointless?
          ds ']D 3W'
          wh '0 }H'
          wh '-.8i }F'
          em '}M'
          nr 'P 1' unless @register['nl'] > 0 and @register['P'] > 0
          pn "#{@register['P']}" unless @register['nl'] > 0 and @register['P'] > 0
          if @register['A'] > 0 and @register['P'] >= @register['A'].value
            ds "PN #{@register['P']}"
            pn '1'
            af '% a'
            nr 'A 0'
          end
          nr 'P 0' if @register['nl'] <= 0 and @register['P'] > 0
          #.if  \\nC .if \\n(nl .bp
          #.if  !\\nC .if \\n(nl .bp 1
          ds "]L modified #{args[2]}"
          nr "]L #{args[2]}"
          rm ']L' if @register[']L'] == 0 # wtf are you guys even doing
          parse '.}E'
          parse '.DT'
          nr ')I .5i'
          nr ')R 1i'
          #mk 'ka'
          #.if !'\\n(ka'-1' .bp
          #.if \\nF .tm .CE MAN-PAGE 1 \\$1(\\$2) \\n%
          #.ev 1
          #.if n .tl \\*(]W\\*(]D\\*(]H
          #.ev
        end
      end
    end
  end

  def self.name_for_section(sec)
    case sec.downcase
    when '1'   then "<strong>#{sec}.</strong> Commands"
    when '1c'  then "<strong>#{sec}.</strong> Communications Commands"
    when '1g'  then "<strong>#{sec}.</strong> Graphics Commands"
    when '1l'  then "<strong>#{sec}.</strong> Commands"
    when '1v'  then "<strong>#{sec}.</strong> System V Commands"
    when '2'   then "<strong>#{sec}.</strong> System Calls"
    when '2v'  then "<strong>#{sec}.</strong> System V Calls"
    when '3'   then "<strong>#{sec}.</strong> C Library"
    when '3c'  then "<strong>#{sec}.</strong> Compatibility Routines"
    when '3f'  then "<strong>#{sec}.</strong> FORTRAN Library"
    when '3j'  then "<strong>#{sec}.</strong> Job Control Facility"
    when '3k'  then "<strong>#{sec}.</strong> Kernel VM Library Funtcions"
    when '3l'  then "<strong>#{sec}.</strong> Lightweight Processes Library"
    when '3m'  then "<strong>#{sec}.</strong> Math Library"
    when '3n'  then "<strong>#{sec}.</strong> Network Support Library"
    when '3r'  then "<strong>#{sec}.</strong> RPC Library"
    when '3s'  then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3v'  then "<strong>#{sec}.</strong> System V Compatibility Routines"
    when '3w'  then "<strong>#{sec}.</strong> OLIT Library"
    when '3x'  then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '3xt' then "<strong>#{sec}.</strong> X Toolkit"
    when '4'   then "<strong>#{sec}.</strong> Device Drivers"
    when '4f'  then "<strong>#{sec}.</strong> Network Protocol Families"
    when '4i'  then "<strong>#{sec}.</strong> IP Special Files and Protocols"
    when '4m'  then "<strong>#{sec}.</strong> STREAMS Module Files"
    when '4n'  then "<strong>#{sec}.</strong> Network Facilities"
    when '4p'  then "<strong>#{sec}.</strong> Network Protocols"
    when '4s'  then "<strong>#{sec}.</strong> Sun-specific Device Special Files"
    when '5'   then "<strong>#{sec}.</strong> File Formats"
    when '5v'  then "<strong>#{sec}.</strong> System V File Formats"
    when '6'   then "<strong>#{sec}.</strong> Games and Demos"
    when '7'   then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '7v'  then "<strong>#{sec}.</strong> System V Miscellaneous Facilities"
    when '8'   then "<strong>#{sec}.</strong> Maintenance Commands"
    when '8c'  then "<strong>#{sec}.</strong> Network Services"
    when '8s'  then "<strong>#{sec}.</strong> Sun-specific Maintenance Commands"
    when '8v'  then "<strong>#{sec}.</strong> System V Maintenance Commands"
    when 'l'   then "<strong>#{sec}.</strong> Local Commands"
    else "Section #{sec}"
    end
  end

  def self.name_for_section_sunos5(sec)
    case sec.downcase
    when '1'    then "<strong>#{sec}.</strong> Commands"
    when '1b'   then "<strong>#{sec}.</strong> SunOS/BSD Compatibility Commands"
    when '1c'   then "<strong>#{sec}.</strong> Communications Commands"
    when '1f'   then "<strong>#{sec}.</strong> FMLI Commands"
    when '1m'   then "<strong>#{sec}.</strong> Maintenance Commands"
    when '1s'   then "<strong>#{sec}.</strong> SunOS-specific Commands"
    when '1x'   then "<strong>#{sec}.</strong> X11 Commands"
    when '2'    then "<strong>#{sec}.</strong> System Calls"
    when '3'    then "<strong>#{sec}.</strong> Functions and Libraries"
    when '3b'   then "<strong>#{sec}.</strong> SunOS/BSD Compatibility Routines"
    when '3c'   then "<strong>#{sec}.</strong> C Library"
    when '3e'   then "<strong>#{sec}.</strong> ELF Library"
    when '3g'   then "<strong>#{sec}.</strong> General Purpose Library"
    when '3i'   then "<strong>#{sec}.</strong> International Library"
    when '3k'   then "<strong>#{sec}.</strong> Kernel VM Library Functions"
    when '3m'   then "<strong>#{sec}.</strong> Math Library"
    when '3n'   then "<strong>#{sec}.</strong> Network Support Library"
    when '3r'   then "<strong>#{sec}.</strong> RPC Library"
    when '3s'   then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3t'   then "<strong>#{sec}.</strong> Threads Library"
    when '3w'   then "<strong>#{sec}.</strong> OLIT Library"
    when '3x'   then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '3x11' then "<strong>#{sec}.</strong> X11 Library"
    when '3xau' then "<strong>#{sec}.</strong> Xauth Library"
    when '3xc'  then "<strong>#{sec}.</strong> X/Open Curses Library"
    when '3xt'  then "<strong>#{sec}.</strong> X Toolkit"
    when '4'    then "<strong>#{sec}.</strong> File Formats"
    when '4b'   then "<strong>#{sec}.</strong> SunOS/BSD File Formats"
    when '5'    then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '6'    then "<strong>#{sec}.</strong> Games and Demos"
    when '7'    then "<strong>#{sec}.</strong> Special Files"
    when '7d'   then "<strong>#{sec}.</strong> Device Special Files"
    when '7fs'  then "<strong>#{sec}.</strong> File Systems Programming Interface"
    when '7i'   then "<strong>#{sec}.</strong> Device Ioctls"
    when '7m'   then "<strong>#{sec}.</strong> STREAMS Module Files"
    when '7p'   then "<strong>#{sec}.</strong> Network Protocols"
    when '8'    then "<strong>#{sec}.</strong> Maintenance Procedures"
    when '9'    then "<strong>#{sec}.</strong> DDI/DKI Interfaces"
    when '9e'   then "<strong>#{sec}.</strong> DDI/DKI Entry Points"
    when '9f'   then "<strong>#{sec}.</strong> DDI/DKI Kernel Functions"
    when '9s'   then "<strong>#{sec}.</strong> DDI/DKI Data Structures"
    else "Section #{sec}"
    end
  end
end
