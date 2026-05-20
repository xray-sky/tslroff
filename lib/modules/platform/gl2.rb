# frozen_string_literal: true
#
# SGI GL1/GL2 Platform Overrides
#
# All versions use basically the same macros.
# The only real variation is in font size, and we don't care about that.
#
# tmac.an
# =======
#
#  TODO
#
# The man command executes manprog that takes a file name as its argument.  Manprog
# calculates and returns a string of three register definitions used by the formatters
# identifying the date the file was last modified.  The returned string has the form:
#    −rdday −rmmonth −ryyear
# and is passed to nroff which sets this string as variables for the man macro package.
# Months are given from 0 to 11, therefore month is always 1 less than the actual month.
# The man macros calculate the correct month.  If the man macro package is invoked as an
# option to nroff/troff (i.e., nroff −man file), then the current day/month/year is used
# as the printed date.
#
# What the hell are \(Dy and \(Dn ?? - section 3G
#
# Alias/1 v2.1 has wrong mod. dates; bad dirs for non-numeric sections; missing 'Version' string
# Version string inappropriate for third party manual entries
# Synopsis & C-TAD (third party) pages are nroff (need page length)
# GL1 W2.3 some of the entries are longer than an enforced 11 character filename limit;
#   presumably these should be renamed for the actual entry, not based on the filename.
#   because of the extensive use of .so we shouldn't use 'title' but maybe just provide a rewrite table
#   look especially in man3g, but we should audit for any others. (audit shows all in man3g.)
# GL2 W2.5 same problem, plus man1d/zshadeabstr, man1m/mklost+foun
# GL1 W2.1 is clean
# W2.1 and W2.3 Mail(1) want to use font T (times?)
# REVIEW tmac.an for .tr *\(** and .ds rq/lq ?? what happened to our defs??
#

module GL2
  class Nroff < Nroff ; end # This is temporarily supporting 4D1 thirdparty
  class Troff < Troff::Man
    alias :LP :P

    def initialize(source, **kwargs)
      #@version ||= "."  # TODO (temporarily supporting 4D1 ThirdParty, but also need to fix os/version for Rake)
      @manual_entry ||= source.file.sub(/\.(\d\S?|man)$/, '')
      @manual_section ||= Regexp.last_match[1] if Regexp.last_match # might not match, e.g. Alias/1 manual
      super(source, **kwargs)
    end

    def init_ds
      super
      @named_strings.merge!(
        {
          'Tm' => '&trade;',
          ']D' => 'Silicon Graphics',
          ']L' => '', # explicitly blanked in .TH before being conditionally redefined
          ']W' => File.mtime(@source.path).strftime("%B %d, %Y"),
          #footer: "Version #{@version.slice(5..-1)}\\0\\0\\(em\\0\\0\\*(]W",
          footer: String.new("Version #{@version.slice(1..-1)}\\0\\0\\(em\\0\\0\\*(]W")
        }
      )
    end

    def init_nr
      @register[')t'] = Troff::Register.new(1) # 8.5" x 11" format (notionally enable) - used in ascii(5)
      @register[')s'] = Troff::Register.new(0) # 6" x 9" format (notionally disable)
    end

    def init_sc
      super
      @special_chars.merge!(
        {
          'ga' => '&#96;' # grave, U0060; this seems to be intended as a spacing character (non-spacing is default, U0300) - see csh(1)
        }
      )
    end

    def init_ta
      @tabstops = %w[3.6m 7.2m 10.8m 14.4m 18m 21.6m 25.2m 28.8m 32.4m 36m 39.6m 43.2m 46.8m].collect { |t| to_u(t).to_i }
      true
    end

    def init_PD
      super
      @register['PD'] = @register[')P']
      @register['IN'] = Troff::Register.new(@base_indent)
    end

    # index info - what even makes sense to do with this
    # probably nothing, as it seems to be for bound manuals (absolute page number)
    def IX(*args) ; end

    def TH(*args)
      ds "]L #{args[2]}" if args[2] and !args[2].strip.empty?
      ds "]D #{args[3]}" if args[3] and !args[3].strip.empty?

      heading = "#{args[0]}\\^(\\^#{args[1]}\\^)\\0\\0\\(em\\0\\0\\*(]D".+@
      heading << ' \\|\\*(]L' unless @named_strings[']L'].empty?

      super(*args, heading: heading)
    end

    def UC(*_args) ; end

  end

  def self.name_for_section(sec)
    case sec.downcase
    when '1'   then "<strong>#{sec}.</strong> Commands"
    when '1c'  then "<strong>#{sec}.</strong> Communications Commands"
    when '1d'  then "<strong>#{sec}.</strong> IRIS GL Demos"
    when '1g'  then "<strong>#{sec}.</strong> Graphics Commands"
    when '1m'  then "<strong>#{sec}.</strong> Maintenance Commands"
    when '1w'  then "<strong>#{sec}.</strong> mex Commands"
    when '2'   then "<strong>#{sec}.</strong> System Calls"
    when '2v'  then "<strong>#{sec}.</strong> System V Calls"
    when '3'   then "<strong>#{sec}.</strong> Subroutines and Libraries"
    when '3b'  then "<strong>#{sec}.</strong> 4.3BSD Compatibility Routines"
    when '3c'  then "<strong>#{sec}.</strong> C Library"
    when '3f'  then "<strong>#{sec}.</strong> FORTRAN Library"
    when '3g'  then "<strong>#{sec}.</strong> IRIX GL Library"
    when '3m'  then "<strong>#{sec}.</strong> Math Library"
    when '3n'  then "<strong>#{sec}.</strong> Network Support Library"
    when '3r'  then "<strong>#{sec}.</strong> RPC Library"
    when '3s'  then "<strong>#{sec}.</strong> Standard I/O Library"
    when '3x'  then "<strong>#{sec}.</strong> Miscellaneous Libraries"
    when '4'   then "<strong>#{sec}.</strong> Special Files"
    when '5'   then "<strong>#{sec}.</strong> File Formats"
    when '5v'  then "<strong>#{sec}.</strong> System V File Formats"
    when '6'   then "<strong>#{sec}.</strong> Games and Demos"
    when '7'   then "<strong>#{sec}.</strong> Miscellaneous Facilities"
    when '7p'  then "<strong>#{sec}.</strong> Network Protocols"
    when '8'   then "<strong>#{sec}.</strong> Maintenance Procedures"
    else sec
    end
  end
end
