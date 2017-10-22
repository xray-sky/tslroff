# troff.rb
# ---------------
#    troff source
# ---------------
#

module Troff

  def source_init

    %w[request escape].each do |t|
      Dir.glob("#{File.dirname(__FILE__)}/troff/#{t}/*.rb").each do |i|
        require i
      end
    end

    require "platform/#{self.platform.downcase}.rb"
    self.extend Kernel.const_get(self.platform.to_sym)

    @state                 = Hash.new
    @state[:escape_char]   = '\\'
    @state[:special_chars] = init_sc
    @state[:font_positions] = %w(_ R I B)

    load_version_overrides

  end

  def to_html
    begin
      l = @lines.next
      parse(l.rstrip)
    rescue StopIteration
      @blocks << @current_block
      blocks.each do |b|
        puts b.to_html
      end
      finished = true
    end until finished  
  end

  def parse(l)
    if l.match(/^([\.\'])\s*(\S{1,2})\s*(\S.*|$)/)
      (x, cmd, req, args) = Regexp.last_match.to_a
      begin
        self.send("req_#{quote_method(req)}", argsplit(args))
      rescue NoMethodError => e
        @current_block << Text.new(text: l, style: Style.new(:unsupported => req))
        @current_block << Text.new
      end
      #@current_block << ' ' unless cmd == "'"
    else
      unescape(l)
    end
  end

  def argsplit(s)
    esc  = Regexp.quote(@state[:escape_char])
    args = Array.new
    until s.empty?
      if s.sub!(/^\"(.+?(#{esc}\")*)(\"|$)/, '') # an open quote may be closed by EOL
        args << Regexp.last_match(1)             # TODO: are single-quoted args allowed??
      else
        s.sub!(/^(.+?(#{esc}\s)*\s*)(\s|$)/, '')
        args << Regexp.last_match(1)
      end
    end
    args
  end

  private
  
  def quote_method(reqstr)
    case reqstr
    when '('  then 'lParen'
    when '\"' then 'BsQuot'
    else           reqstr
    end
  end

  def unescape(str)
    begin
      ec = @state[:escape_char]
      parts = str.partition(ec)
      @current_block << parts[0] unless parts[0].empty?

      if parts[1] == ec
        str = case parts[2][0]
              when ec  then parts[2]
              when '_' then parts[2]                                         # underrule, equivalent to \(ul
              when '-' then parts[2].sub(/^-/, '&minus;')                    # "minus sign in current font"
              when ' ' then parts[2].sub(/^ /, '&nbsp;')                     # "unpaddable space-sized character"
              when '%' then parts[2].sub(/^%/, '&shy;')                      # discretionary hyphen
              when '|' then parts[2].sub(/^\|/, '<span class="nrs"></span>') # 1/6 em      narrow space char
              when '^' then parts[2].sub(/^\^/, '<span class="hns"></span>') # 1/12em half-narrow space char
              when '(' then parts[2].sub(/^\((..)/, esc_lParen(Regexp.last_match[1]))
              when 'e' then @current_block << ec 
                            parts[2].sub(/^e/, '')                           # current escape character
              when 'f' then parts[2].match(/^f#{Regexp.quote(ec)}?(\S)/)     # handle \f\P wart in ftp.1c [GL2-W2.5]
                            (esc_seq, font_req) = Regexp.last_match.to_a
                            case font_req
                            when /\d/ then apply { @current_block.text.last.font.face = @state[:font_position][font_req] }
                            when 'R'  then apply { @current_block.text.last.font.face = :regular }
                            when 'B'  then apply { @current_block.text.last.font.face = :bold }
                            when 'I'  then apply { @current_block.text.last.font.face = :italic }
                            when 'P'  then f = @current_block.text[-2].font.face
                                           @current_block << Text.new(font: @current_block.text.last.font.dup, 
                                                                      style: @current_block.text.last.style.dup)
                                           @current_block.text.last.font.face = f
                            else          "<span style=\"color:blue\">unselected font #{Regexp.last_match(1)}</span>"
                            end
                            parts[2].sub(/#{esc_seq}/, '')
              else     "<span style=\"color:blue;\">#{parts[2]}</span>"      # TODO: temporary for debugging; ordinarily it should just return escaped char for unknowns
              end
      else
        str = parts[2]
      end

    end until str.empty?

  end

end
