# troff.rb
# ---------------
#    troff source
# ---------------
#

require 'shellwords'

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
    begin
      @source.lines.each do |l|

        #if l.match(/^(['\.])(.[a-zA-Z"]?)(.*)/)
        if l.match(/^([\.\'])\s*(\S{1,2})\s*(\S.*|$)/)
          req = quote_req($2)
          if self.respond_to?("req_#{req}")
            args = Shellwords.split($3)
            self.send("req_#{req}", args)
          else
             @current_block.append(TaggedText.new(args,{:unsupported => ($1+$2)}))
          end
          @current_block.append(" ") unless $1 == "'"
        else
          #puts "FOO: #{l}"
          @current_block.append("#{l} ")
        end
      
      end

    rescue ImmutableStyleError
      @blocks << @current_block
      @current_block = StyledObject.new
      retry
    end

    @blocks << @current_block

  end

  private
  
  def quote_req ( reqstr )
    case reqstr
      when '\"' then "BsQuot"
      else           reqstr
    end
  end
	
end