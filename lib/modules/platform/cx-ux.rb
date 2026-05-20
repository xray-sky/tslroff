# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# Concurrent CX/UX Platform Overrides
#
# TODO
#
#   font shme: \f3 (if not bold), \f4, \f5, \fl
#   extensive use of \f4 (which is... what?)
#   use of \fL right next to \f4 in acc_vector(4) so probably that's not in the running
#   use of \fl in sar(1m) - what is that
#   use of \f5 in sendmail(1m), addseverity(3c), fmtmsg(3c), admin(1) - what is that, maybe CW. used in section 3c for console output
#   use of \f3 in several pages in section 7 - for subsection head, and once in text as emphasis (almost certainly plain bold)
#   use of \f3 in ar(4), fs(4)
#

module CX_UX
  class Nroff < Nroff
    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.(\d\S*?)(?:\.z)?$/, '') # nroff pages are compressed
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      super(source, **kwargs)
    end
  end

  class Troff < Troff::Man
    alias :LP :P

    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.(\d\S*?)(?:\.z)?$/, '') # troff pages are compressed
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      super(source, **kwargs)
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          footer:"\\*(]W".+@,
          #'Tm' => '&trade;',
          ']W' => File.mtime(@source.path).strftime('%B %d, %Y')
        }
      )
    end

    def init_fp
      super
      # REVIEW - going with solaris troff assignments:
      mount_font 4, 'BI' # not fully convinced of this one
      mount_font 5, 'CW'
      # still don't know what \fl is
    end

    def init_tr
      super
      @character_translations['*'] = "\e(**"
    end

    def init_TH
      #super
      @register['IN'] = Troff::Register.new(@base_indent)
    end

    def TH(*args)
      #ds ']W 7th Edition' # tmac.an.new
      #ds ']D 32B Virtual UNIX Programmer\'s Manual' # tmac.an.new
      ds "]L #{args[2]}"
      ds "]W #{args[3]}"
      ds "]D #{args[4]}"

      heading = "#{args[0]}\\|(\\|#{args[1]}\\|)".+@
      heading << '\\0\\0\\(em\\0\\0\\*(]L' unless @named_strings[']L'].empty?
      @named_strings[:footer] << '\\0\\0\\(em\\0\\0\\*(]D' unless @named_strings[']D'].empty?

      super(*args, heading: heading)
    end

  end

  def self.name_for_section(sec)
    case sec.downcase
    when '1'   then "<strong>#{sec}.</strong> Commands"
    when '1c'  then "<strong>#{sec}.</strong> Communications Commands"
    when '1g'  then "<strong>#{sec}.</strong> Graphics Commands"
    when '1m'  then "<strong>#{sec}.</strong> Maintenance Commands"
    when '2'   then "<strong>#{sec}.</strong> System Calls"
    when '2p4' then "<strong>#{sec}.</strong> POSIX System Calls"
    when '3'   then "<strong>#{sec}.</strong> Subroutines and Libraries"
    when '3c'  then "<strong>#{sec}.</strong> C Library"
    when '3f'  then "<strong>#{sec}.</strong> FORTRAN Library"
    when '3m'  then "<strong>#{sec}.</strong> Math Library"
    when '3n'  then "<strong>#{sec}.</strong> Network Support Library"
    when '3p4' then "<strong>#{sec}.</strong> POSIX Compatibility Routines"
    when '3r'  then "<strong>#{sec}.</strong> RPC Library"
    when '3s'  then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3x'  then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '4'   then "<strong>#{sec}.</strong> File Formats"
    when '4c'  then "<strong>#{sec}.</strong> Network File Formats"
    when '4f'  then "<strong>#{sec}.</strong> Network Protocol Families"
    when '4n'  then "<strong>#{sec}.</strong> Network Facilities"
    when '4p'  then "<strong>#{sec}.</strong> Network Protocols"
    when '5'   then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '6'   then "<strong>#{sec}.</strong> Games"
    when '7'   then "<strong>#{sec}.</strong> Special Files"
    when '7c'  then "<strong>#{sec}.</strong> Communications Special Files"
    when '8'   then "<strong>#{sec}.</strong> Maintenance Procedures"
    else "Section #{sec}"
    end
  end
end
