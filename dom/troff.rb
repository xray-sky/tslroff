# troff.rb
# ---------------
#    troff source
# ---------------
#


module Troff

	def source_init

        %w( request escape ).each do |t|
          Dir.glob("#{File.dirname(__FILE__)}/troff/#{t}/*.rb").each do |i|
            require i
          end
        end

		require "platform/#{self.platform.downcase}.rb"
		self.extend Kernel.const_get(self.platform.to_sym)

		load_version_overrides

	end
	
  def parse
	@source.lines.each do |l|

      if l.match(/^['\.](.[a-zA-Z"])(.*)/)
        req = self.quote_req($1)
         if self.respond_to?("req_#{req}")
           self.send("req_#{req}", $2)
         end
      else
        puts "FOO: #{l}"
      end
	end
  end
	
  def quote_req ( reqstr )
    case reqstr
      when '\"' then "BsQuot"
      else           reqstr
    end
  end
	
end