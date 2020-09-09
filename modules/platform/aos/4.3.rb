# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 10/7/19.
# Copyright 2019 Typewritten Software. All rights reserved.
#
#
# IBM AOS 4.3 Platform Overrides
#

module AOS_4_3

  def init_rewrites
    case File.basename(@source.filename)
    when 'ftp.1c'
      newsrc = @source.lines
      newsrc[210].sub!(/f$/, 'fP')
      @lines = newsrc.each
    when 'mdtar.1'
      newsrc = @source.lines
      newsrc[96].sub!(/\\\*$/, '')
      newsrc[102].sub!(/\\\*$/, '') # REVIEW nroff ignores these, but ought they be changed to * here?
      @lines = newsrc.each
    end
  end

  #def parse ( lines = @source.lines )
  #  super
  #  self.apply { @current_block.text << Text.new(:text => "super.", :style => Style.new(:grated => true)) }
  #end
  #
=begin

  # NOTES
  #
  # bitmap.1 has \fP wart in summary line 14
  # fpr.1 needs override for tbl (postprocess replaced with preprocess) lines 27-171
  # xterm.1 has \B and means \fB line 1316

  several IBM pages appear to have been replaced by 4BSD pages (updates?):
    as.1
    date.1
    dbx.1
    error.1
    f77.1
    ld.1
    mset.1
    pprint.1
    tn3270.1
    vgrind.1
    htonl.3n
    floor.3m
    hypot.3m
    ... basically it looks like anything reporting a Berkeley Distribution in the footer.

  several IBM pages are missing:
    andrew.1
    dumpapa8.1
    dumpapa8c.1
    kbdlock.1
    pp.1 (was replaced with original hc.1)
    support.1
    up.1
    xwindows.1
    vdspin.2
    vdstats.2
    intro.3x

  some IBM pages are somewhat different from the printed manual (or replaced by 7th ed?):
    learn.1
    mt.1
    pf.1
    pic.1
    ptroff.1
    tar.1
    sigvec.2 (...+others)
    intro.3
    abort.3
    ecvt.3
    frexp.3

    atof.3

  intro.2 is incomplete
  ieee.3 is incomplete

=end

end


