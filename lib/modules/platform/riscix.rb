# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Acorn RISCix Platform Overrides
#

class RISCiX
  class Troff < Troff

    alias :LP :P

    def initialize(source)
      @manual_entry ||= source.file.sub(/\.(\d\S*)$/, '')
      @manual_section ||= Regexp.last_match[1]
      super(source)
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          ']D' => 'UNIX Programmer\'s Manual',
          ']W' => '7th Edition',
          footer: "\\*(]W"
        }
      )
    end

    def init_tr
      super
      @character_translations['*'] = "\e(**"
    end

    def init_PD
      super
      @register['IN'] = Troff::Register.new(@base_indent)
    end

    # "some support to get the RCS format date into a more normal text form (dd/mm/yy)"
    def dA(*args)
      send 'rR', *(args[0]&.split('/'))
    end

    # "puts new date format in string Da"
    def rR(*args)
      ds "Da #{args[2]}/#{args[1]}/#{args[0]}"
    end

    # "An Acorn specific macro to put revision number / date
    #  into the footer of the manual page from information
    #  provided by RCS. The argument is of form:
    #  .AH $Revision: 1.5 $ $Date: 88/10/20 11:12:34 $"
    def AH(*args)
      send 'dA', args[4]
      ds "]L Revision #{args[1]} of \\*(Da"
    end

    def AT(*args)
      ds ']W ' + case args[0]
                 when '3' then '7th Edition'
                 when '4' then 'System III'
                 when '5' then "System V#{" Release #{args[1]}" if args[1] and !args[1].empty?}"
                 else '7th Edition'
                 end
    end

    def DE(*_args)
      fi
      send 'RE'
      sp '.5'
    end

    def DS(*_args)
      send 'RS'
      nf
      sp
    end

    # indexing and other undefined macros. ignore.
    def BY(*_args) ; end
    def iX(*_args) ; end
    def IX(*_args) ; end # defined in tmac.s
    def SB(*_args) ; end # REVIEW this one looks like we lost content
    def TX(*_args) ; end
    def UX(*_args) ; end # defined in tmac.s

    def TH(*args)
      ds "]L #{args[2]}"
      ds "]W #{args[3]}" if args[3] and !args[3].strip.empty?
      ds "]D #{args[4]}" if args[4] and !args[4].strip.empty?

      heading = "#{args[0]}\\|(\\|#{args[1]}\\|)\\0\\0\\(em\\0\\0\\*(]D"
      @named_strings[:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @named_strings[']L'].empty?

      super(*args, heading: heading)
    end

    def UC(*args)
      ds ']W ' + case args[0]
                 when '3' then '3rd Berkeley Distribution'
                 when '4' then '4th Berkeley Distribution'
                 when '5' then '4.2 Berkeley Distribution'
                 when '6' then '4.3 Berkeley Distribution'
                 else '3rd Berkeley Distribution'
                 end
    end

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

  end
end
