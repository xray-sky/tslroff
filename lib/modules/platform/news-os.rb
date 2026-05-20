# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/12/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# NEWS-os Platform Overrides
#
# TODO
#   several of the MH pages want to use the T, M, and X fonts (what are they)
#

module NEWS_os
  class Nroff < Nroff ; end
  class Troff < Troff::Man

    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.([\dnop][^.]*)$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      super(source, **kwargs)
    end

    def init_tr
      super
      @character_translations['*'] = "\e(**"
    end

    def init_TH
      #super
      @register['IN'] = Register.new(@base_indent)
    end

    # doesn't matter, ]W not used in header or footer
    def AT(*args)
      ds ']W ' + case args[0]
                 when '3' then '7th Edition'
                 when '4' then 'System III'
                 when '5' then "System V#{" Release #{args[1]}" if args[1] and !args[1].empty?}"
                 else '7th Edition'
                 end
    end

    # index info - what even makes sense to do with this
    # probably nothing, as it seems to be for bound manuals (absolute page number)
    def iX(*_args) ; end
    def IX(*_args) ; end

    def TH(*args)
      ds "]L #{args[2]}"
      ds "]W #{args[3]}" if args[3] and !args[3].strip.empty?
      ds "]D #{args[4]}" if args[4] and !args[4].strip.empty?

      heading = "#{args[0]}\\|(\\|#{args[1]}\\|)".+@
      heading << '\\0\\0\\(em\\0\\0\\*(]D' unless @named_strings[']D'].empty?

      super(*args, heading: heading)
    end

    # doesn't matter, ]W not used in header or footer
    def UC(*args)
      ds ']W ' + case args[0]
                 when '3' then '3rd Berkeley Distribution'
                 when '4' then '4th Berkeley Distribution'
                 when '5' then '4.2 Berkeley Distribution'
                 when '6' then '4.3 Berkeley Distribution'
                 else '3rd Berkeley Distribution'
                 end
    end

    # good news - margin characters don't seem to be used anywhere in the Sony manual
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
    when '1'      then "<strong>#{sec}.</strong> Commands"
    when '1a'     then "<strong>#{sec}.</strong> Maintenance Commands"
    when '1c'     then "<strong>#{sec}.</strong> Communications Commands"
    when '1f'     then "<strong>#{sec}.</strong> FMLI Commands"
    when '1g'     then "<strong>#{sec}.</strong> Graphics Commands"
    when '1j'     then "<strong>#{sec}.</strong> Japanese Commands"
    when '1v'     then "<strong>#{sec}.</strong> POSIX/System V Commands"
    when '1m'     then "<strong>#{sec}.</strong> Maintenance Commands"
    when '2'      then "<strong>#{sec}.</strong> System Calls"
    when '2v'     then "<strong>#{sec}.</strong> POSIX/System V System Calls"
    when '3'      then "<strong>#{sec}.</strong> C Library"
    when '3c'     then "<strong>#{sec}.</strong> Compatibility Routines"
    when '3f'     then "<strong>#{sec}.</strong> FORTRAN Library"
    when '3f7768' then "<strong>#{sec}.</strong> M68k FORTRAN Library"
    when '3j'     then "<strong>#{sec}.</strong> Japanese Language Processing Functions"
    when '3m'     then "<strong>#{sec}.</strong> Math Library"
    when '3n'     then "<strong>#{sec}.</strong> Network Support Library"
    when '3v'     then "<strong>#{sec}.</strong> POSIX Compatibility Routines"
    when '3r'     then "<strong>#{sec}.</strong> RPC Library"
    when '3s'     then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3x'     then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '3x11'   then "<strong>#{sec}.</strong> X11 Library"
    when '3xext'  then "<strong>#{sec}.</strong> X11 Extensions"
    when '3xi'    then "<strong>#{sec}.</strong> X Input Library"
    when '3xm'    then "<strong>#{sec}.</strong> Motif Library"
    when '3xt'    then "<strong>#{sec}.</strong> X Toolkit"
    when '4'      then "<strong>#{sec}.</strong> Special Files"
    when '4c'     then "<strong>#{sec}.</strong> Network File Formats"
    when '4f'     then "<strong>#{sec}.</strong> Network Protocol Families"
    when '4n'     then "<strong>#{sec}.</strong> Network Facilities"
    when '4p'     then "<strong>#{sec}.</strong> Network Protocols"
    when '4v'     then "<strong>#{sec}.</strong> POSIX/System V Special Files"
    when '5'      then "<strong>#{sec}.</strong> File Formats"
    when '5v'     then "<strong>#{sec}.</strong> POSIX/System V File Formats"
    when '6'      then "<strong>#{sec}.</strong> Games"
    when '7'      then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '8'      then "<strong>#{sec}.</strong> Maintenance Procedures"
    when '8c'     then "<strong>#{sec}.</strong> Network Services"
    else "Section #{sec}"
    end
  end
end
