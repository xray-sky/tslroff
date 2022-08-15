# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 10/7/19.
# Copyright 2019 Typewritten Software. All rights reserved.
#
#
# IBM AOS 4.3 Platform Overrides
#

module AOS_4_3

  def self.extended(k)
    case k.instance_variable_get '@input_filename'
    # REVIEW maybe this kind of thing should be left alone?
    when 'f77.1'
      k.instance_variable_get('@source').lines[277].sub!(/^/, "\\&")	# non-macro line starts with .
    when 'fpr.1'  # there's a preprocessed tbl in here, but also some comments with the tbl input which we should use instead
      newsrc = k.instance_variable_get('@source').lines
      (28..37).each { |i| newsrc[i].sub!(/^\.\\"\s/, '') }
      (40..156).each { |i| newsrc[i] = '\"' }
    # REVIEW maybe this kind of thing should be left alone?
    when 'ftp.1c'
      k.instance_variable_get('@source').lines[210].sub!(/f$/, 'fP')
    when 'help.1'	# also in olh.1 but uses .so
      k.instance_variable_get('@source').lines[20].sub!(/^/, "\\&")	# non-macro line starts with '
    when 'mdtar.1'
      k.instance_variable_get('@source').lines[96].sub!(/\\\*\s+$/, '*')
      k.instance_variable_get('@source').lines[102].sub!(/\\\*$/, '*') # nroff ignores these, but they are intended to output
    when 'mouse.4'  # there's preprocessed eqn in here, but also some comments with the eqn input which we should use instead
      newsrc = k.instance_variable_get('@source').lines
      (122..140).each { |i| newsrc[i].sub!(/^\.\\"/, '') }
      newsrc[254].sub!(/t/, 'n')
    #when 'Script', 'Scrit'
    #  raise ManualIsBlacklisted, 'not a manual entry'
    end
  end

  # zwgc(1) wants to call this directly, from local .TQ:
  # TODO: implement .di for this to work.
  #
  # .de TQ
  # .if !"\\$1"" .nr )I \\$1n
  # .ne 1.1v
  # .in \\n()Ru
  # .nr )E 1
  # .ns
  # .it 1 }N
  # .di ]B
  # ..
  #
  # handle end of 1-line features
  # .de }N
  # .if \\n()E .br
  # .di
  # .if "\\n()E"0" .}f
  # .if "\\n()E"1" .}1
  # .if "\\n()E"2" .}2
  # .nr )E 0
  # ..

  def req_rcurlN
    # TODO: ugh.
  end
end

=begin
aliases(5) has "SEE&nbsp; ALSO"
mh-chart(1) wants special attention!
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
