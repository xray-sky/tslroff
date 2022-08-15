# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 10/07/19.
# Copyright 2019 Typewritten Software. All rights reserved.
#
#
# IBM AOS Platform Overrides (tmac.an.new)
#
#  .tr *\(**	-- TODO when .tr can handle this sort of construct
#
# Three part title }H (head)
#  .tl @\\*(]H@\\*(]D@\\*(]H@	::	nam(sec)	Unix Programmer's Manual		nam(sec)
#
# Three part title }F (foot)
#  .tl @\\*(]W@\\*(]L@%@		::	7th Edition			TH$3					\n%
#
# .de TH
#   .nr IN .5i
#   .ds ]H $1\|(\|$2\|)
#   .ds ]L $3
#   .if $4 is set .ds ]W $4 else .ds ]W "7th Edition"
#   .if $5 is set .ds ]D $5 else .ds ]D "Unix Programmer's Manual"
#   put }H at top of page
#   put }F an inch from bottom
#
# TODO
#   we definitely have to delay header/footer processing until end of processing
#

module AOS

  def self.extended(k)
    k.define_singleton_method(:req_LP, k.method(:req_PP)) if k.methods.include?(:req_PP)
    k.instance_variable_set '@manual_entry',
       k.instance_variable_get('@input_filename').sub(/\.(\d\S?)$/, '')
    k.instance_variable_set '@manual_section', Regexp.last_match[1]
    k.instance_variable_set '@output_directory', "man#{k.instance_variable_get '@manual_section'}"
    #k.instance_variable_get('@state')[:footer] = "\\*(]D\\0\\0\\(em\\0\\0\\*(]W"
  end


  def init_sc
    super
    @state[:special_char].merge!({
      'ga'  => '&lsquo;',	# this 'accent' character is intended to be non-combining
      'aa'  => '&rsquo;',	# this 'accent' character is intended to be non-combining
    })
  end

  def init_ds
    super
    @state[:named_string].merge!({
      # tmac.an.new
      'R'  => '&reg;',
      'S'  => "\\s#{Font.defaultsize}",
      'lq' => '&ldquo;',
      'rq' => '&rdquo;',
      ']D' => 'Unix Programmer\'s Manual',  # default set by .TH
      ']W' => '7th Edition',                # default set by .TH
      #']W' => File.mtime(@source.filename).strftime("%B %d, %Y"),
    })
  end

  def req_AC(*args)
    req_ds(']W', 'IBM ACIS')	# REVIEW where the hell is this defined?
  end

  # tmac.an.new
  def req_AT(*args)
    req_ds(']W', case args[0]
                 when '4' then 'System III'
                 when '5' then "System V#{' Release ' + args[1] if args[1]}"
                 else '7th Edition'
                 end
          )
  end

  def req_DS
    req_fi
    req_RE
    req_sp('.5')
  end

  def req_TH(*args)
    heading = "#{args[0]}\\^(\\^#{args[1]}\\^)"
    if args[4]
      req_ds(']D', args[4])
      #@state[:footer] = "\\*(]W" if args[4].strip.empty?
      unescape((args[4].strip.empty? ? "\\*(]W" : "\\*(]D\\0\\0\\(em\\0\\0\\*(]W"), output: @state[:footer])
    end
    req_ds(']W', args[3]) if args[3]
    if args[2]
      req_ds(']L', args[2])
      unescape('\\0\\0\\(em\\0\\0\\*(]L', output: @state[:footer]) unless args[2].strip.empty?
    end
    super(heading: heading)
  end

  def req_VE
    warn "can't yet draw margin characters (.mc)"
  end

  # tmac.an.new
  def req_UC(v = nil)
    req_ds(']W', case v
                 when '4' then '4th Berkeley Distribution'
                 when '5' then '4.2 Berkeley Distribution'
                 when '6' then '4.3 Berkeley Distribution'
                 else '3rd Berkeley Distribution'
                 end
          )
  end
end
