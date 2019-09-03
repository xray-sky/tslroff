# troff.rb
# ---------------
#    troff source
# ---------------
#

module Troff
  def source_init
    %w[request macro escape].each do |t|
      Dir.glob("#{File.dirname(__FILE__)}/troff/#{t}/*.rb").each do |i|
        require i
      end
    end

    require "modules/platform/#{self.platform.downcase}.rb"
    self.extend Kernel.const_get(self.platform.to_sym)

    @state                = Hash.new

    load_version_overrides

    # call any initialization methods for .nr, .ds, etc.
    # may be supplemented or overridden by version-specific methods

    self.methods.each do |m|
      self.send(m) if m.to_s.match(/^init_/)
    end
  end

  def to_html
    loop do
      begin
        l = @lines.next
        parse(l.rstrip)
      rescue StopIteration
        @document << @current_block
        return @document.collect(&:to_html).join
      end
    end
  end

  def parse(l)
    # Multiple inter-word space characters found in the input are retained except for
    # trailing spaces. §4.1
    l.rstrip!
    if l.match(/^([\.\'])\s*(\S{1,2})\s*(\S.*|$)/)
      (x, cmd, req, args) = Regexp.last_match.to_a
      warn "bare tab in #{cmd}#{req} args (#{args.inspect})" if args.include?("\t") and req != '\"'
      begin
        send("req_#{Troff.quote_method(req)}", *argsplit(args))
        # troff considers a macro line to be an input text line
        space_adj if Troff.macro?(req)
      rescue NoMethodError => e
        # Control lines with unrecognized names are ignored. §1.1
        if e.message.match(/^undefined method `req_/)
          warn "Unrecognized request: #{l}"
        else
          # it's some other screwup; use the normal error reporting
          warn "in line #{l.inspect}:"
          warn e
          warn e.backtrace
        end
      end
    else
      case l
      # A blank text line causes a break and outputs a blank line
      # exactly like '.sp 1' §5.3
      when /^$/  then broke? ? req_br(nil) : req_br(nil);req_br(nil) unless @current_block.type == :cell
      # initial spaces also cause a break. §4.1
      # -- but don't break again unnecessarily.
      # -- REVIEW: I think tabs don't count for this
      when /^ +/ then broke? ? '' : req_br(nil)
      end

      warn "bare tab in input (#{l.inspect})" if l.include?("\t")
      unescape(l)
      space_adj
    end

    # REVIEW: this break might also need to happen during macro processing
    req_br(nil) unless fill? || broke? || cmd == "'"
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

  def break_adj
    # TODO: this
  end

  def space_adj
    return if @current_block.empty? || continuation?
    # An input text line ending with ., ?, !, .), ?), or !) is taken to be the end
    # of a sentence, and an additional space character is automatically provided during
    # filling.  §4.1
    sentence_end? and @current_block << ' '
    @current_block << ' '
  end

  def self.macro?(req)
    req.length.between?(1,2) and req.upcase == req
  end

  def continuation?
    @current_block.to_s.match(/&roffctl_continuation;$/)
  end

  def sentence_end?
    @current_block.text.last.text.match(/(?:\!|\.|\?)\)?$/)
  end

  def broke?
    @current_block.text.last.text.match(/&roffctl_br;\s+$/)
  end

  def fill?
    @state[:register]['.u'].zero? ? false : true
  end

  def cm_unescape(str)
    copy = String.new
    begin
      esc   = @state[:escape_char]
      parts = str.partition(esc)
      copy << parts[0] unless parts[0].empty?

      if parts[1] == esc
        str = case parts[2][0]
              # TODO: \$, \t, \a, \", concealed new-line
              when esc then parts[2]  # REVIEW: is this actually right??
              when '.' then parts[2]
              when /[*n]/
                esc_method = "esc_#{Troff.quote_method(parts[2][0])}"
                if respond_to?(esc_method)
                  send(esc_method, parts[2])
                else
                  warn "unescaped char in copy mode #{parts[2][0]} (#{parts[2][1..-1]})"
                  parts[2]
                end
              else copy << esc ; parts[2]
              end
      else
        str = parts[2]
      end

    end until str.empty?
    copy
  end

  def unescape(str)
    @state[:translate].any? and str.gsub!(/[#{Regexp.quote(@state[:translate].keys.join)}]/) { |c| @state[:translate][c] }
    esc = @state[:escape_char]
    begin
      parts = str.partition(esc)
      @current_block << parts[0].sub(/&roffctl_esc;/, esc) unless parts[0].empty? # str might begin with esc

      if parts[1] == esc
        str = case parts[2][0]
              when esc then parts[2].sub(/^#{Regexp.quote(esc)}/, '&roffctl_esc;')  # REVIEW: is this actually right?? does changing it prevent \*S from working??
              when '_' then parts[2]                             # underrule, equivalent to \(ul
              when '-' then parts[2].sub(/^-/,  '&minus;')       # "minus sign in current font"
              when ' ' then parts[2].sub(/^ /,  '&nbsp;')        # "unpaddable space-sized character"
              when '0' then parts[2].sub(/^0/,  '&ensp;')        # "digit-width space" - possibly "en space"?
              when '%' then parts[2].sub(/^%/,  '&shy;')         # discretionary hyphen
              when '&' then parts[2].sub(/^\&/, '&zwj;')         # "non-printing, zero-width character" - possibly "zero-width joiner"
              when "'" then parts[2].sub(/^\'/, '&acute;')       # "typographically equivalent to \(aa" §23.
              when '`' then parts[2].sub(/^\`/, '&#96;')         # "typographically equivalent to \(ga" §23.
              when '|' then parts[2].sub(/^\|/, '&roffctl_nrs;') # 1/6 em      narrow space char
              when '^' then parts[2].sub(/^\^/, '&roffctl_hns;') # 1/12em half-narrow space char
              when 'c' then parts[2].sub(/^c/,  '&roffctl_continuation;') # continuation (shouldn't have been space-adjusted)
              else
                esc_method = "esc_#{Troff.quote_method(parts[2][0])}"
                if respond_to?(esc_method)
                  send(esc_method, parts[2])
                else
                  warn "unescaped char #{parts[2][0]} (#{parts[2][1..-1]})"
                  parts[2]
                end
              end
      else # no esc chars remain in str
        str = parts[2]
      end

    end until str.empty?
  end

  def self.quote_method(reqstr)
    case reqstr
    when '*'  then 'star'
    when '('  then 'lparen'
    when '\"' then 'BsQuot'
    when 'T&' then 'TAmp'
    else           reqstr
    end
  end

end
