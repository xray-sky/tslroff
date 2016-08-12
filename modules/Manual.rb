# Created by R. Stricklin <bear@typewritten.org> on 05/14/14.
# Copyright 2014 Typewritten Software. All rights reserved.
#
#
# Manual class
# Just a delegatation to platform-specific methods
#

require "modules/Source.rb"

class Manual
		
	attr_reader :platform, :version
	
	def initialize( file )

	#temporary hardcode for early prototyping
    @platform = "SunOS"
    @version = "4_1_4"
	#end temporary hardcode

		@blocks = Array.new
		@lines = Source.new( file )
	
		require "dom/#{@lines.type.downcase}"
		self.extend Kernel.const_get(@lines.type.to_sym)
		
		load_platform_overrides
		
	end
  
end