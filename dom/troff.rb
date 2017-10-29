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
    @state[:fill]          = true
    @state[:escape_char]   = '\\'
    @state[:special_chars] = init_sc
    @state[:named_strings] = init_ns
    @state[:numeric_reg]   = Array.new
    @state[:font_pos]      = [nil, :regular, :italic, :bold]

    load_version_overrides
  end

  def to_html
    loop do
      begin
        l = @lines.next
        parse(l.rstrip)
      rescue StopIteration
        @blocks << @current_block
        return @blocks.collect(&:to_html).join
      end
    end
  end

  def parse(l)
    # Multiple inter-word space characters found in the input are retained except for
    # trailing spaces. §4.1
    l.rstrip!
    if l.match(/^([\.\'])\s*(\S{1,2})\s*(\S.*|$)/)
      (x, cmd, req, args) = Regexp.last_match.to_a
      begin
        send("req_#{Troff.quote_method(req)}", argsplit(args))
      rescue NoMethodError => e
        # Control lines with unrecognized names are ingored. §1.1
        warn "Unrecognized request: #{l}"
      end
    else
      @current_block << case l
                        # A blank text line causes a break and outputs a blank line 
                        # exactly like '.sp 1' §5.3
                        when /^$/   then '&troff_br;&troff_br;'
                        # initial spaces also cause a break. §4.1
                        # -- but don't break again unnecessarily.
                        when /^\s+/ then @current_block.text.last.text.match(/&troff_br;\s+$/) ? '' : '&troff_br;'
                        else             ''
                        end

      unescape(l)
    end

    # An input text line ending with ., ?, !, .), ?), or !) is taken to be the end
    # of a sentence, and an additional space character is automatically provided during
    # filling.  §4.1
    @current_block.text.last.text.match(/(?:\!|\.|\?)\)?$/) and @current_block << ' '

    @current_block << ' '

    req_br(nil) unless @state[:fill] || cmd == "'"
  end

  def argsplit(s)
    esc  = Regexp.quote(@state[:escape_char])
    args = Array.new
    until s.empty?
      if s.sub!(/^\"(.+?(#{esc}\")*)(\"|$)/, '') # an open quote may be closed by EOL
        args << Regexp.last_match(1)             # REVIEW: are single-quoted args allowed??
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
    begin
      esc   = @state[:escape_char]
      parts = str.partition(esc)
      @current_block << parts[0] unless parts[0].empty?

      if parts[1] == esc
        str = case parts[2][0]
              when esc then parts[2]  # REVIEW: is this actually right?? does changing it prevent \*S from working??
              when '_' then parts[2]                           # underrule, equivalent to \(ul
              when '-' then parts[2].sub(/^-/,  '&minus;')     # "minus sign in current font"
              when ' ' then parts[2].sub(/^ /,  '&nbsp;')      # "unpaddable space-sized character"
              when '0' then parts[2].sub(/^0/,  '&ensp;')      # "digit-width space" - possibly "en space"?
              when '%' then parts[2].sub(/^%/,  '&shy;')       # discretionary hyphen
              when '&' then parts[2].sub(/^\&/, '&zwj;')       # "non-printing, zero-width character" - possibly "zero-width joiner"
              when "'" then parts[2].sub(/^\'/, '&acute;')     # "typographically equivalent to \(aa" §23.
              when '`' then parts[2].sub(/^\`/, '&#96;')       # "typographically equivalent to \(ga" §23.
              when '|' then parts[2].sub(/^\|/, '&troff_nrs;') # 1/6 em      narrow space char
              when '^' then parts[2].sub(/^\^/, '&troff_hns;') # 1/12em half-narrow space char
              else
                esc_method = "esc_#{Troff.quote_method(parts[2][0])}"
                # TODO: temporary for debugging; ordinarily it should just return escaped char for unknowns
                respond_to?(esc_method) ? send(esc_method, parts[2]) : %(<span class="u">#{parts[2][0]}</span>#{parts[2][1..-1]})
              end
      else
        str = parts[2]
      end

    end until str.empty?
  end
end
