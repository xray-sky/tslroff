# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 08/21/22.
# Copyright 2022 Typewritten Software. All rights reserved.
#
#
# Ultrix 2.0.0 Platform Overrides
#
# TODO
#   check odd eaten spaces in WS-1.1 2780e(1), 3780e(1), maybe ar(1) -- others?
#    - definitely a regression ; 2.0.0 was ok until re-processed, now eaten spaces
#    - check the ultrix macro defs for unexpected side-effects
#   missing sections in cmd refs, e.g. WS-1.1 cc(1) ?
#   mail(1) wants to use font T - is it same as TR? - probably Times actually
#   cc(1) + others have both courier AND the DEC monospaced font override?
#   cdc(1) loses monospaced font in the middle of the last EXAMPLE?
#

module Ultrix_2_0_0

  def self.extended(k)
  end

  def init_ds
    super
    @state[:named_string].merge!({
      ']D' => 'UNIX Programmer\'s Manual',
      ']W' => '7th Edition',
      :footer => '' # just a page number
    })
  end

  define_method 'TH' do |*args|
    heading = "#{args[0]}\\|(\\|#{args[1]}\\|)" # tmac.an uses \f(TB
    super(*args, heading: heading)
  end

end
