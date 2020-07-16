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

module AOS

  def load_version_overrides
    require "modules/platform/#{self.platform.downcase}/#{self.version}.rb"
    self.extend Kernel.const_get("#{self.platform}_#{self.version}".to_sym)
  end

  #def parse(l)
  #  # TODO: this is just a test of the modular bug rewrite capability.
  #  #       it is working; this is an FSF (linux) bug though.
  #  case File.basename(@source.filename)
  #  when 'man.1'
  #    l.sub!(/^'html'/, "\\\\&'html'")
  #  end
  #  super
  #end

  def init_ds
    super
    @state[:named_string].merge!({
      # I think these are always in tmac.an
      #'R'  => '&reg;',
      #'S'  => "\\s#{Font.defaultsize}",
      # these aren't in tmac.an -- where do they come from?
      #'Tm' => '&trade;',
      # tmac.an.new
      'lq' => '&ldquo;',
      'rq' => '&rdquo;',
      ']D' => 'Unix Programmer\'s Manual',  # default set by .TH
      ']W' => '7th Edition'                 # default set by .TH
      #']W' => File.mtime(@source.filename) # REVIEW: probably this is incorrectly formatted for matching whatever it ought to look like
    })
  end

  def req_AC(*args)
    req_ds(']W', 'IBM ACIS')	# REVIEW where the hell is this defined?
  end

  # tmac.an.new
  def req_AT(*args)
    req_ds(']W', case args[0]
                 when '4' then 'System III'
                 when '5' then args[1].nil? ? 'System V' : "System V Release #{args[1]}"
                 else '7th Edition'
                 end
          )
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

  def req_DS
    req_fi
    req_RE
    req_sp('.5')
  end

  #/Users/bear/Unix/git/tslroff/modules/platform/aos.rb:80:in `<module:AOS>': undefined method `req_PP' for module `AOS' (NameError)
  #alias req_LP req_PP

end