# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 05/10/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# SunOS Platform Overrides
#

module SunOS

  #def parse(l)
  #  # TODO: this is just a test of the modular bug rewrite capability.
  #  #       it is working; this is an FSF (linux) bug though.
  #  case File.basename(@source.filename)
  #  when "man.1"
  #    l.sub!(/^'html'/, "\\\\&'html'")
  #  end
  #  super
  #end

  # TODO: these aren't sunos named strings, just samples for testing
  def init_ds
    super
    @state[:named_string].merge!({
      #'R'  => '&reg;',
      #'S'  => "\\s#{Font.defaultsize}",
      'Tm' => '&trade;',
      'lq' => '&ldquo;',
      'rq' => '&rdquo;',
      ']D' => 'Silicon Graphics',
      ']W' => File.mtime(@source.filename) # REVIEW: probably this is incorrectly formatted for matching whatever it ought to look like
    })
  end

end


