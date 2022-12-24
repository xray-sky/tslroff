# troff.rb
# ---------------
#    troff main
# ---------------
#
# REVIEW: add anchors menu for .SH ?

require 'selenium-webdriver'
%w[. request escape macro eqn tbl].each do |t|
  Dir.glob("#{__dir__}/troff/#{t}/*.rb").each do |i|
    require_relative i
  end
end

module Troff

  @@delim = %(\002\003\005\006\007"')
  @@requests = instance_methods.select { |m| m.start_with? 'req_' }.map { |m| m.slice(4..-1) }

  def self.requests
    @@requests
  end

  def self.webdriver
    @@webdriver
  end

  def self.extended(k)
    k.extend ::Eqn
    k.extend ::Tbl
    k.instance_variable_set '@register', {}
    k.instance_variable_set '@state', { :header => Block::Header.new,
                                        :footer => Block::Footer.new }
    k.instance_variable_set '@related_info_heading', %r{SEE(?: |&nbsp;)+ALSO}
  end

  def source_init
    # call any initialization methods for .nr, .ds, etc.
    # may be supplemented or overridden by version-specific methods
    # REVIEW do this in a grown up way - these need ordered to succeed
    #  - if left to random wildcard chance, may throw exceptions

    xinit_selenium
    xinit_ec
    xinit_nr
    xinit_in

    self.methods.each do |m|
      self.send(m) if m.to_s.start_with? 'init_'
    end

    parse_title
  end

  def to_html
    @current_block = blockproto
    @document << @current_block
    loop do
      parse(next_line)
    rescue StopIteration
      # TODO perform end-of-input trap macros from .em;
      # REVIEW maybe make the closing divs happen that way. or clean up the way the open divs get inserted.
      unescape @state[:named_string][:header], output: @state[:header]
      @document.insert(0, @state[:header])
      if @state[:named_string][:footer]
        unescape @state[:named_string][:footer], output: @state[:footer]
        @document << @state[:footer]
      end
      return @document.collect(&:to_html).join + "\n    </div>\n</div>" # REVIEW closes main doc divs start ed by :th
    rescue => e
      warn "#{@line.inspect} -"
      warn e
      warn e.backtrace.join("\n")
    end
  end

  private

  def debug(line, *msg)
    warn (['debug: ']+(msg.collect(&:inspect))).join(' ') if input_line_number == line
  end

  def input_line_number
    @register['.c']&.value || 0
  end

  def next_line
    #line = @lines.tap { @register['.c'].incr }.next.chomp.tap { |n| warn "reading new line #{n.inspect}" } # REVIEW do we ever need to perserve the trailing \n ?
    line = @lines.tap { @register['.c'].incr }.next.chomp # REVIEW do we ever need to perserve the trailing \n ?

    # Hidden newlines -- REVIEW does this need to be any more sophisticated?
    # REVIEW might be space adjusted? see synopsis, fsck(1m) [GL2-W2.5]
    # TODO the new-line at the end of a comment cannot be concealed.
    # Doing it here means I don't have to do it everywhere we are doing local next_lines (.TS, .if, etc.)
    # But, this will give us "bad" line numbers for warnings. I can probably live with that.
    if @state[:escape_char]
      if line.end_with?(@state[:escape_char]) and line[-2] != @state[:escape_char]
        line.chop! << next_line
      end
    end
    @line = line
  end

  # TODO find where we're inserting paragraphs (with and without margin-top:0) containing only
  #      a single space. these are being output but are apparently irrelevant/invisible.
  #      might have to do an a/b comparison to be sure. e.g. eqn(1) [SunOS 5.5.1]

  # prototype a new block with whatever necessary styles carried forward.
  def blockproto(type = Block::Paragraph)
    break_adj # eat a break at the end of a block; this wouldn't have whitespaced. but html will REVIEW is this working??
              # - no, it's eating the final break in a nofill, when we go to .ig! but we don't need blockproto in .ig
              #   so that is the solution for now. but watch this.
    type = Block::Monospace if @state[:cs]
    block = type.new
    block.style[:section] = @state[:section] if @state[:section]
    block.style[:linkify] = true if @state[:section] =~ @related_info_heading
    block.style.css[:margin_top] = "#{to_em(@register[')P'])}em" unless @register[')P'] == @state[:default_pd]
    block.style.css[:margin_top] = '0' if nospace? #if nofill? or nospace?
    block.style.css[:margin_left] = "#{to_em(@register['.i'])}em"
    block.style.css.delete(:margin_left) if @register['.i'] == @state[:base_indent]
    block.style.css[:text_align] = [ 'left', 'justify', nil, 'center', nil, 'right' ][@register['.j']] unless @register['.j'] == 1
    block.style.css[:text_align] = 'left' if noadj?		# .na sets left adjust without changing .j
    block.style.attributes[:class] = 'synopsis' if @state[:section]&.match?(/^synopsis$/i) and block.is_a? Block::Paragraph
    block
  end

  def get_title
    @current_block = blockproto
    @document << @current_block
    loop do
      parse(next_line)
      break if @manual_section
    end
    true if @manual_section
  #ensure
    #@lines.rewind
  end

  def parse_title
    # parse as far as the title, so we can have the odir immediately after
    # a Manual.new, then if we want to continue (aren't just figuring out
    # a symlink target), then just continue on.
    get_title or warn "reached end of document without finding title!"
    @output_directory = "man#{@manual_section.downcase}" if @manual_section
  end
end
