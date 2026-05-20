# frozen_string_literal: true
# encoding: UTF-8
#
# Created by R. Stricklin <bear@typewritten.org> on 08/23/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Kodak/SunSoft Interactive UNIX Platform Overrides
#
# TODO
#

module Interactive
  class Nroff < Nroff
    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.([n\d]\S*)$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      @heading_detection ||= %r(^\s{10}(?<section>[A-Z][A-Za-z\s]+)$)
      @title_detection ||= %r{^\s{10}(?<manentry>(?<cmd>\S+?)\((?<section>\S+?)\))}
      super(source, **kwargs)
    end
  end

  class Troff < Troff::Man
    alias :LP :P

    def initialize(source, **kwargs)
      @manual_entry ||= source.file.sub(/\.([n\d]\S*)$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match
      super(source, **kwargs)
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          footer: '\\fB\\s-1\\*(]Y\\0\\0\\(em\\0\\0\\*(]Z\\s+1\\fP'.+@,
          'Tm' => '&trade;',
          'E'  => '\\&.\|.\|.',
          'T'  => "\t",
          # these are probably version 4 specific
          'U'  => 'INTERACTIVE UNIX System',
          'U2' => 'INTERACTIVE UNIX System',
          'UF' => 'INTERACTIVE UNIX System',
          'UH' => 'INTERACTIVE UNIX System',
          'UU' => 'INTERACTIVE UNIX System',
          'sA' => 'Base', # System Accounting Subset
          'sC' => 'Base', # Core Subset
          'sF' => 'Text Processing', # Text Formatting Subset
          'sG' => 'Base', # Games Subset
          'sI' => 'Base', # INpackages
          'sN' => 'Base', # Networking Subset
          'sP' => 'Software Development', # Programming Subset
          'sS' => 'Software Development', # SCCS Subset
          'sT' => 'Text Processing', # Typesetting and Terminal Filters Subset
          'Nn' => 'INTERACTIVE UNIX System 80386',
          ']D' => '', # blanked for troff in .TH
          ']L' => '', # conditionally defined in .TH
          ']U' => File.mtime(@source.path).strftime("%B %d, %Y"),
          ']Y' => '\\*U',
          ']Z' => 'Version \\|1.0'
        }
      )
    end

    def init_nr
      @register['PD'] = @register[')P']         # Interactive .PD sets \n(PD instead of \n()P
      @register[')f'] = Troff::Register.new(3)  # bold font (for some reason)
      @register[')t'] = Troff::Register.new(1)  # 8.5" x 11" format (notionally enable)
      @register[')s'] = Troff::Register.new(0)  # 6" x 9" format (notionally disable)
    end

    def init_ta
      @tabstops = %w[3.6m 7.2m 10.8m 14.4m 18m 21.6m 25.2m 28.8m 32.4m 36m 39.6m 43.2m 46.8m].collect { |t| to_u(t).to_i }
      true
    end

    def init_TH
      #super
      @register['IN'] = Troff::Register.new(@base_indent)
    end

    # whoa, danger
    def Pp(*args)
      warn ".Pp attempting to include process output from #{args.inspect} ?!"
      #system "#{args[0]} #{args[1]} >/tmp/DIT.#{Process.pid}"
      #so "/tmp/DIT.#{Process.pid}"
      #File.delete "/tmp/DIT.#{Process.pid}"
    end

    def BA(*args)
      return nil.tap { warn ".BA has illegal number of args - #{args.inspect}" } unless args.any? and args.count < 3
      send 'RB', '[\\0', "\\&#{args[0]}", "#{args[1]}\\0]\\%"
    end

    def BX(*args)
      warn ".BX wants to draw box from #{args.inspect} - punt"
      unescape args.join(' ')
    end

    def IN(*args)
      parse "\\s-1INTERACTIVE\\s+1#{args[0]}"
    end

    def LR(*args)
      send 'SH', "LICENSE REQUIRED"
      parse "This entry applies only to the #{args[0]} license."
    end

    # small caps
    def SC(*args)
      if args.any?
        parse '.nr ;S \\n(.s'
        ps
        parse '.nr ;G \\n(.s' # ...silly. but, they do it. and it prevents last size from getting progressively smaller
        ps
        if args.count > 2
          parse "#{args[0]}\\s-1#{args[1]}\\s+1#{args[2]}"
        else
          parse "\\s-1#{args[0]}\\s+1#{args[1]}"
        end
        parse '.ps \\n(;G'
        parse '.ps \\n(;S'
      else
        ps "#{Font.defaultsize}-1"
        it '1 }f'
      end
    end

    def TH(*args)
      #ds "]H #{args[0]}\\^(\\^#{args[1]}\\^)"
      # cut mark stuff, output from }C, along with ]U and ]V
      #ds "]W Rev. #{args[2]}"
      #ds "]T #{args[3]}"
      ds("]L (\\^#{args[4]}\\^)") if args[4] and !args[4].strip.empty?

      heading = "#{args[0]}\\^(\\^#{args[1]}\\^)".+@
      heading << "\\0\\0\\(em\\0\\0\\*(]L" if @named_strings[']L']

      super(*args, heading: heading)
    end

    # 4.0 aborts when encountering these macros; we'll just warn
    def obsolete_macro(*_args)
      warn "encountered obsolete macro #{__callee__}"
    end

    %w[PM DE DS SB VX].each do |m|
      alias_method m, :obsolete_macro
    end

  end

  def self.name_for_section(sec)
    case sec.downcase
    when '1'    then "<strong>#{sec}.</strong> Commands"
    when '1c'   then "<strong>#{sec}.</strong> Communications Commands"
    when '1g'   then "<strong>#{sec}.</strong> Graphics Commands"
    when '1m'   then "<strong>#{sec}.</strong> Maintenance Commands"
    when '1p'   then "<strong>#{sec}.</strong> POSIX Commands"
    when '2'    then "<strong>#{sec}.</strong> System Calls"
    when '2p'   then "<strong>#{sec}.</strong> POSIX System Calls"
    when '3'    then "<strong>#{sec}.</strong> Subroutines and Libraries"
    when '3c'   then "<strong>#{sec}.</strong> C Library"
    when '3m'   then "<strong>#{sec}.</strong> Math Library"
    when '3n'   then "<strong>#{sec}.</strong> Network Support Library"
    when '3p'   then "<strong>#{sec}.</strong> POSIX Compatible Routines"
    when '3s'   then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3x'   then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '4'    then "<strong>#{sec}.</strong> File Formats"
    when '4p'   then "<strong>#{sec}.</strong> POSIX File Formats"
    when '5'    then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '5p'   then "<strong>#{sec}.</strong> POSIX Facilities"
    when '7'    then "<strong>#{sec}.</strong> Special Files"
    when '7n'   then "<strong>#{sec}.</strong> Networking Facilities"
    when '8'    then "<strong>#{sec}.</strong> Maintenance Commands"
    else "Section #{sec}"
    end
  end
end
