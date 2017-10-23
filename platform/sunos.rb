# encoding: US-ASCII
#
# Created by R. Stricklin <bear@typewritten.org> on 05/10/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# SunOS Platform Overrides
#

module SunOS

  def load_version_overrides
    require "platform/#{self.platform.downcase}/#{self.version}.rb"
    self.extend Kernel.const_get("#{self.platform}_#{self.version}".to_sym)
  end

  #def parse ( lines = @source.lines )
  #  puts "well?"
  #  super
  #end

  # TODO: these aren't sunos named strings, just samples for testing
  def init_ns
    {
      'S'  => "\\s#{Font.defaultsize}",
      'R'  => '&reg;',
      'Tm' => '&trade;',
      'lq' => '&ldquo;',
      'rq' => '&rdquo;',
      ']D' => 'Silicon Graphics',
      ']W' => 'xTIMEx'                    # TODO: this file's modification time
    }
  end

end


