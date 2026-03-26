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

class CX_UX

  class Nroff < Nroff
    def initialize(source)
      @manual_entry ||= source.file.sub(/\.(\d\S*?)(?:\.z)?$/, '') # nroff pages are compressed
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      super(source)
    end
  end

  class Troff < Troff

    alias :LP :P

    def initialize(source)
      @manual_entry ||= source.file.sub(/\.(\d\S*?)(?:\.z)?$/, '') # troff pages are compressed
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      super(source)
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          footer:"\\*(]W",
          #'Tm' => '&trade;',
          ']W' => File.mtime(@source.path).strftime('%B %d, %Y')
        }
      )
    end

    def init_fp
      super
      # REVIEW - going with solaris troff assignments:
      @mounted_fonts[4] = 'BI' # not fully convinced of this one
      @mounted_fonts[5] = 'CW'
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

    define_method 'TH' do |*args|
      #ds ']W 7th Edition' # tmac.an.new
      #ds ']D 32B Virtual UNIX Programmer\'s Manual' # tmac.an.new
      ds "]L #{args[2]}"
      ds "]W #{args[3]}"
      ds "]D #{args[4]}"

      heading = "#{args[0]}\\|(\\|#{args[1]}\\|)"
      heading << '\\0\\0\\(em\\0\\0\\*(]L' unless @named_strings[']L'].empty?
      @named_strings[:footer] << '\\0\\0\\(em\\0\\0\\*(]D' unless @named_strings[']D'].empty?

      super(*args, heading: heading)
    end

  end
end
