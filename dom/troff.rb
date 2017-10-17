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

    @esc_chars = init_sc

  end
	
  def parse
    @held = [ nil, 0 ]
    @source.lines.each do |l|
        #if l.match(/^(['\.])(.[a-zA-Z"]?)(.*)/)
        if l.match(/^([\.\'])\s*(\S{1,2})\s*(\S.*|$)/)
          req = quote_req($2)
          if self.respond_to?("req_#{req}")
            args = Shellwords.split($3)
            self.send("req_#{req}", args)
          else
             @current_block << Text.new(:text => $3.inspect, :style => Style.new(:unsupported => req))
             @current_block << Text.new
          end
          @current_block << " " unless $1 == "'"
        else
          if @held[1] > 0
            self.send("held_#{@held[0]}".to_sym, l)
            @held[1] -= 1
          else
            @current_block << "#{l} "
          end
        end
      
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