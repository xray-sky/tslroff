# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 10/7/19.
# Copyright 2019 Typewritten Software. All rights reserved.
#
#
# IBM AOS 4.3 Platform Overrides
#

module AOS_4_3

  #def parse ( lines = @source.lines )
  #  super
  #  self.apply { @current_block.text << Text.new(:text => "super.", :style => Style.new(:grated => true)) }
  #end
  #
  # NOTES
  #
  # bitmap.1 has \fP wart in summary line 14
  # fpr.1 needs override for tbl (postprocess replaced with preprocess) lines 27-171
  # xterm.1 has \B and means \fB line 1316

end


