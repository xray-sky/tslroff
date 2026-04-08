# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/04/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Gould G-NIX Platform Overrides
#
# head - .tl @\\*(]H@\\*(]D@\\*(]H@
# foot - .tl @\\*(]W@\\*(]L@%@
# TODO:
#   many pages have un-expanded SCCS ID keywords (%W% %Q% %Y% in the footer, in .NOP)
#   -- the formatted pages have values set for these, but where did they come from?
#      and are the formatted pages otherwise the same??
#      (No, in at least the case of section 5 pages with .so into /usr/include)
# √ apl.1 :: overstrikes -> I-beam is >2chr; character centers not aligned, e.g. lamp
#            might be best just to rewrite them as single chars, if possible
#   ms.7 :: [96] has ^A in input. why? formatted page shows no character output.
#           doc says "all other" characters are ignored -
#           printing ascii, SOH, HTAB, NL, BS passed through for output
#           SOH, STX, ETX, ENQ, ACK, BEL all suppressed for output in troff unless translated
#           "unless in copy mode, the ASCII backspace char is replaced by a backward horizontal
#            motion having the width of the space character."
#
# .so:
# uulog.1c [1]: .so can't read /usr/man/man1/uucp.1
# uulog.1c [1]: .so can't read /usr/man/man1/uucp.1
# stat.2 [46]: .so can't read /usr/include/sys/stat.h
# time.2 [38]: .so can't read /usr/include/sys/timeb.h
# times.2 [26]: .so can't read /usr/include/sys/times.h
# ctime.3 [54]: .so can't read /usr/include/time.h
# getgrent.3 [34]: .so can't read /usr/include/grp.h
# getpwent.3 [33]: .so can't read /usr/include/pwd.h
# acct.5 [17]: .so can't read /usr/include/sys/acct.h
# ar.5 [36]: .so can't read /usr/include/ar.h
# filsys.5 [32]: .so can't read /usr/include/sys/filsys.h
# filsys.5 [70]: .so can't read /usr/include/sys/fblk.h
# filsys.5 [217]: .so can't read /usr/include/sys/ino.h
# types.5 [15]: .so can't read /usr/include/sys/types.h
# utmp.5 [18]: .so can't read /usr/include/utmp.h

module GDT_UNX
  class Manual < Manual
    def initialize(file, vendor_class: nil, source_args: {})
      case File.basename file
      when 'Script', 'Scrit' then raise ManualIsBlacklisted, 'not a manual entry'
      end
      super file, vendor_class: vendor_class, source_args: source_args
    end
  end

  class Nroff < Nroff
    def initialize(source)
      @manual_entry ||= source.file.sub(/\.(\d\S?)$/, '')
      @manual_section ||= Regexp.last_match[1]

      super(source)
      case @source.file
      # REVIEW there are several pages that exist as 'copy___'. are these all strict duplicates?
      # cpmcopy.9 is ~66 lines per page but the first page is short. Insert extra lines after the title.
      when 'cpmcopy.9' then @source.lines.insert(25, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
      end
    end
  end

  class Troff < Troff
    alias :LP :P

    def initialize(source)
      @manual_entry ||= source.file.sub(/\.(\d\S?)$/, '')
      @manual_section ||= Regexp.last_match[1]
      super(source)
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          footer: "\\*(]W".+@,
          ']D' => "UNIX Programmer's Manual",
          # REVIEW ]W is overridden with '7th Edition' in .TH, but the manuals in cat*/
          # have the date. among other things that don't quite match tmac.an ..?
          #']W' => '7th Edition',
          ']W' => File.mtime(@source.path).strftime('%B %d, %Y')
        }
      )
    end

    def init_tr
      super
      @character_translations['*'] = "\\(**"
    end

    def init_PD
      super
      @register['IN'] = Troff::Register.new(@base_indent)
    end

    # REVIEW
    # this is used seemingly to prevent processing the next line
    # as a request. but, it's not in tmac.an or the DWB manual.
    def li(*_args)
      parse "\\&#{next_line}"
    end

    # .so with absolute path, headers in /usr/include
    def so(name, breaking: nil, basedir: nil)
      basedir = "#{@source.dir}#{"/../.." if name.start_with?('/')}"
      super(name, breaking: breaking, basedir: basedir)
    end

    def TH(*args)
      ds "]L #{args[2]}"

      heading = "#{args[0]}\\|(\\|#{args[1]}\\|)\\0\\0\\(em\\0\\0\\*(]D"
      @named_strings[:footer] << '\\0\\0\\(em\\0\\0\\*(]L' unless @named_strings[']L'].empty?

      super(*args, heading: heading)
    end

    # tmac.an.new
    def UC(v = '', *_args)
      ds "]W #{v.empty? ? '3rd Berkeley Distribution' : "#{v}th Berkeley Distribution"}"
    end

    # .NOP - does nothing but I would like to insert this text as a comment
    def NO(*args)
      comment = *args.join(' ').slice(1..-1) # kill the initial P (from .NOP)
      send '\\"', comment
    end

  end
end
