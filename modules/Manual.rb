# Created by R. Stricklin <bear@typewritten.org> on 05/14/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# Manual class
# Just a delegatation to platform-specific methods
#

require "modules/Source.rb"
require "modules/StyledObject.rb"
require "modules/TaggedText.rb"

class Manual

  attr_accessor :blocks
  attr_reader   :platform, :version
	
  def initialize ( file )

      #temporary hardcode for early prototyping
        @platform = "SunOS"
        @version = "4_1_4"
      #end temporary hardcode

    @blocks = Array.new
    @source = Source.new( file )
    @current_block = StyledObject.new

    require "dom/#{@source.magic.downcase}"
    self.extend Kernel.const_get(@source.magic.to_sym)
	
    source_init
	
  end

end