# SGI GL2 Platform Overrides
#
# tmac.an
# =======
#
# }H
#   .ie\\*(]L .tl \\*(]H\\*(]D\\*(]H
#   .el       .tl \\*(]H\\*(]D \|\\*(]L\\*(]H
#
# }F
#   .if o .tl 'Page %''\\*(]W'
#   .if e .if !\\nv+1 .tl '\\*(]W''Page %'
#
# TH
#   .ift      .ds ]H \\$1\^(\^\\$2\^)
#   .if\\n()t .ds ]D Silicon Graphics
#             .ds ]L
#   .if!\\$3  .ds ]L (\^\\$3\^)
#   .if!\\$4  .ds ]D \\$4
#
# .ifn     \{.ie \nd .ds ]W (last mod. \nm/\/nd\/ny)
#            .el.ds      ]W (printed \n(mo/\n(dy/\n(yr)
# .if\n()t \{.ie \nd .ds ]W \*(]m \nd, 19\ny
#            .el.ds      ]W \*(]m \n(dy, 19\n(yr
#
# ]m is full month
#
# I don't understand where \nd comes from, but it seems pretty clear from the
# preformatted pages in the GL2-W2.5 image that the "normal" behavior is to put
# "last mod. {file timestamp}" in the footer.
#
# "normal" footer behavior is    page n                          last mod. (timestamp)
#
# "normal" header behavior is    NAME(SEC)          Silicon Graphics         NAME(SEC)
# ping(8) has                    PING(8)    Silicon Graphics (May 23, 1986)    PING(8)
#           --> this is .TH arg  $1   $2    $4                $3
#
#  TODO:
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
# GL1 W2.3 has 29 Sep 2021 as footer date. probably want to address that.
# GL1 W2.3 some of the entries are longer than an enforced 11 character filename limit;
#   presumably these should be renamed for the actual entry, not based on the filename.
#   because of the extensive use of .so we shouldn't use 'title' but maybe just provide a rewrite table
#   look especially in man3g, but we should audit for any others. (audit shows all in man3g.)
# GL2 W2.5 same problem, plus man1d/zshadeabstr, man1m/mklost+foun
# GL1 W2.1 is clean
#

module GL2

  def self.extended(k)
    k.define_singleton_method(:req_LP, k.method(:req_PP)) if k.methods.include?(:req_PP)
  end

  def init_gl2
    @manual_entry     = @input_filename.sub(/\.(\d\S?)$/, '')
    @manual_section   = Regexp.last_match[1]
    @output_directory = "man#{@manual_section}"
    @state[:footer] = "\\*(]W"
  end

#  def init_so
#    @state[:path_translations] = { %r{/usr} => '' }
#  end

  def init_ds
    super
    @state[:named_string].merge!({
      'R'  => '&reg;',
      'S'  => "\\s#{Font.defaultsize}",
      'Tm' => '&trade;',
      'lq' => '&ldquo;',
      'rq' => '&rdquo;',
      ']D' => 'Silicon Graphics',
      ']W' => File.mtime(@source.filename).strftime("%B %d, %Y")
    })
  end

  def init_nr
    @register[')t'] = Troff::Register.new(1)	# 8.5" x 11" format (notionally enable) - used in ascii(5)
    @register[')s'] = Troff::Register.new(1)	# 6" x 9" format (notionally disable)
  end

  def init_sc
    super
    @state[:special_char].merge!({
      'ga'  => '&#96;'		# grave, U0060; this seems to be intended as a spacing character (non-spacing is default, U0300) - see csh(1)
    })
  end

  def init_ta
    @state[:tabs] = [ '3.6m', '7.2m', '10.8m', '14.4m', '18m', '21.6m', '25.2m', '28.8m',
                      '32.4m', '36m', '39.6m', '43.2m', '46.8m' ].collect { |t| to_u(t).to_i }
    true
  end

  def req_TH(*args)
    heading = "#{args[0]}\\^(\\^#{args[1]}\\^)"
    if args[2]
      req_ds(']L', args[2]) # "(\\^#{args[2]}\\^)") <= this is how it was in the perl version
      heading << '\\0\\0\\(em\\0\\0\\*(]L' unless args[2].strip.empty?
    end
    req_ds(']D', args[3]) if args[3]
    heading << '\\0\\0\\(em\\0\\0\\*(]D'
    super(*args, heading: heading)
  end

  def init_PD
    super
    @register['PD'] = @register[')P']
    @register['IN'] = Troff::Register.new(@state[:base_indent])
  end

end


