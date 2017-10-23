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
    @state[:named_strings] = init_ns
    @state[:font_pos]      = [nil, :regular, :italic, :bold]
    @state[:numeric_reg]   = Array.new

    load_version_overrides

  end

  def to_html
    begin
      l = @lines.next
      parse(l.rstrip)
    rescue StopIteration
      @blocks << @current_block
      return @blocks.collect(&:to_html).join
    end while true
  end

  def parse(l)
    if l.match(/^([\.\'])\s*(\S{1,2})\s*(\S.*|$)/)
      (x, cmd, req, args) = Regexp.last_match.to_a
      begin
        send("req_#{Troff.quote_method(req)}", argsplit(args))
      rescue NoMethodError => e
        @current_block << Text.new(text: l, style: Style.new(:unsupported => req))
        @current_block << Text.new
      end
    else
      unescape(l)
    end
    @current_block << ' ' unless cmd == "'"
  end

  def argsplit(s)
    esc  = Regexp.quote(@state[:escape_char])
    args = Array.new
    until s.empty?
      if s.sub!(/^\"(.+?(#{esc}\")*)(\"|$)/, '') # an open quote may be closed by EOL
        args << Regexp.last_match(1)             # TODO: are single-quoted args allowed??
      else
        s.sub!(/^\s*(.+?(#{esc}\s)*\s*)(\s|$)/, '')
        args << Regexp.last_match(1)
      end
    end
    args
  end

  private
  
  def self.quote_method(reqstr)
    case reqstr
    when '*'  then 'star'
    when '('  then 'lparen'
    when '\"' then 'BsQuot'
    else           reqstr
    end
  end

  def unescape(str)
    str.gsub!(/[<>]/) do |c|
      case c
      when '<' then '&lt;'
      when '>' then '&gt;'
      end
    end
    begin
      esc   = @state[:escape_char]
      parts = str.partition(esc)
      @current_block << parts[0] unless parts[0].empty?

      if parts[1] == esc
        str = case parts[2][0]
              when esc then parts[2]
              when '_' then parts[2]                                         # underrule, equivalent to \(ul
              when '-' then parts[2].sub(/^-/, '&minus;')                    # "minus sign in current font"
              when ' ' then parts[2].sub(/^ /, '&nbsp;')                     # "unpaddable space-sized character"
              when '%' then parts[2].sub(/^%/, '&shy;')                      # discretionary hyphen
              when '|' then parts[2].sub(/^\|/, '<span class="nrs"></span>') # 1/6 em      narrow space char
              when '^' then parts[2].sub(/^\^/, '<span class="hns"></span>') # 1/12em half-narrow space char
              else
                esc_method = "esc_#{Troff.quote_method(parts[2][0])}"
                respond_to?(esc_method) ? send(esc_method, parts[2]) : "<span class=\"u\">#{parts[2][0]}</span>#{parts[2][1..-1]}" # TODO: temporary for debugging; ordinarily it should just return escaped char for unknowns
              end
      else
        str = parts[2]
      end

    end until str.empty?

  end

end
