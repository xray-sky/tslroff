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

    @state                 = Hash.new
    @state[:escape_char]   = '\\'
    @state[:req_held]      = Array.new
    @state[:special_chars] = init_sc

    load_version_overrides

  end

  def to_html 
    begin
      l = @lines.next
      parse(l)
    rescue StopIteration
      @blocks << @current_block
      blocks.each do |b|
        puts b.to_html
      end
      finished = true
    end until finished  
  end

  def parse ( l )
    if l.match(/^([\.\'])\s*(\S{1,2})\s*(\S.*|$)/)
      req = quote_method($2)
      if self.respond_to?("req_#{req}")
        args = argsplit($3)				# TODO shellwords is eating my \ 
        self.send("req_#{req}", args)
      else
        @current_block << Text.new(:text => $3.inspect, :style => Style.new(:unsupported => req))
        @current_block << Text.new
      end
      @current_block << " " unless @state[:req_held].any? or $1 == "'"
    else
      unescape(l)
    end
  end

  def argsplit ( s )
    esc  = Regexp.quote(@state[:escape_char])
    args = Array.new
    until s.empty?
      if s.sub!(/^\"(.+?(#{esc}\")*)(\"|$)/, '')	# an open quote may be closed by EOL
        args << $1									# TODO are single-quoted args allowed??
      else
        s.sub!(/^(.+?(#{esc}\s)*\s*)(\s|$)/, '')
        args << $1
      end
    end
    args
  end

  private
  
  def quote_method ( reqstr )
    case reqstr
      when '('  then "lParen"
      when '\"' then "BsQuot"
      else           reqstr
    end
  end

  def unescape ( str )
    parts = Array.new

    begin
      parts = str.partition(@state[:escape_char])
      @current_block << parts[0] unless parts[0].empty?

      if parts[1] == @state[:escape_char]
        str = case parts[2][0]
          when @state[:escape_char] then parts[2]
          when "_"                  then parts[2]                                         # underrule, equivalent to \(ul
          when "e"                  then @current_block << @state[:escape_char] 
                                         parts[2].sub(/^e/, '')                           # current escape character
          when "-"                  then parts[2].sub(/^-/, '&minus;')                    # "minus sign in current font"
          when " "                  then parts[2].sub(/^ /, '&nbsp;')                     # "unpaddable space-sized character" 
          when "%"                  then parts[2].sub(/^%/, '&shy;')                      # discretionary hyphen
          when "|"                  then parts[2].sub(/^\|/, '<span class="nrs"></span>') # 1/6 em      narrow space char
          when "^"                  then parts[2].sub(/^\^/, '<span class="hns"></span>') # 1/12em half-narrow space char
          when "("                  then parts[2].sub(/^\((..)/, self.esc_lParen($1))
          else                           "<span style=\"color:blue;\">#{parts[2]}</span>"
        end
      else
        str = parts[2]
      end

    end until str.empty?

  end

end