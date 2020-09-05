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

module GL2

  def self.extended(klasse)
    klasse.send(:instance_eval, 'alias req_LP req_PP')
  end

  def init_footer
    @state[:footer] = "\\*(]D\\0\\0\\(em\\0\\0\\*(]W"
  end

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


end


