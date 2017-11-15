# nroff.rb
# ---------------
#    nroff source
# ---------------
#


module Nroff

	def load_platform_overrides

		require "platform/#{self.platform.downcase}.rb"
		self.extend Kernel.const_get(self.platform.to_sym)

		load_version_overrides

	end
	
	def parse
		puts "I guess it might work."
	end
	
end