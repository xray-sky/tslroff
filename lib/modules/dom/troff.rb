# troff.rb
# ---------------
#    troff main
# ---------------
#
# REVIEW: add anchors menu for .SH ?

require 'selenium-webdriver'

module Troff

  @@delim = %(\002\003\005\006\007"')

  def source_init(titled: false)
    %w[. request escape macro].each do |t|
      Dir.glob("#{__dir__}/troff/#{t}/*.rb").each do |i|
        require_relative i
      end
    end

    @register = {}
    @state    = {}
    @related_info_heading = %r{SEE(?: |&nbsp;)+ALSO}

    load_platform_overrides
    load_version_overrides

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

    parse_title unless titled # I'll want to re-init after looking for the title
    # TODO is this even necessary? I'm parsing stuff too many times, including
    # everything twice for every .so (.so parses everything once, looking for title, then again processing the doc)
    # perhaps this can be combined with the improvement for delaying <h1> for .ds, etc.
  end

  def to_html
    @current_block = blockproto
    @document << @current_block
    loop do
      parse(next_line)
    rescue StopIteration
      # TODO: perform end-of-input trap macros from .em;
      @current_block = Block.new
      @document << @current_block
      @current_block.style.attributes[:class] = 'foot'
      #@current_block << '&ensp;&ensp;&mdash;&ensp;&ensp;'
      unescape(@state[:footer] || '') # may not have got a footer (esp. if parse_title didn't find one)
      #@current_block << '&ensp;&ensp;&mdash;&ensp;&ensp;'
      # REVIEW: maybe make the closing divs happen that way. or clean up the way the open divs get inserted.
      return @document.collect(&:to_html).join + "\n    </div>\n</div>" # REVIEW: closes main doc divs start ed by :th
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
    @line = @lines.tap { @register['.c'].incr }.next.chomp # REVIEW do we ever need to perserve the trailing \n ?
    #@line = @lines.tap { @register['.c'].incr }.next.chomp.tap { |n| warn "reading new line #{n.inspect}" }
  end

  # prototype a new block with whatever necessary styles carried forward.
  def blockproto(type = :p)
    break_adj # eat a break at the end of a block; this wouldn't have whitespaced. but html will REVIEW is this working??
              # - no, it's eating the final break in a nofill, when we go to .ig! but we don't need blockproto in .ig
              #   so that is the solution for now. but watch this.
    type = :cs if @state[:cs]
    block = Block.new(type: type)
    block.style[:section] = @state[:section] if @state[:section]
    block.style[:linkify] = true if @state[:section] =~ @related_info_heading
    block.style.css[:margin_top] = "#{to_em(@register[')P'])}em" unless @register[')P'] == @state[:default_pd]
    block.style.css[:margin_top] = '0' if nospace? #if nofill? or nospace?
    block.style.css[:margin_left] = "#{to_em(@register['.i'])}em"
    block.style.css.delete(:margin_left) if @register['.i'] == @state[:base_indent]
    block.style.css[:text_align] = [ 'left', 'justify', nil, 'center', nil, 'right' ][@register['.j']] unless @register['.j'] == 1
    block.style.css[:text_align] = 'left' if noadj?		# .na sets left adjust without changing .j
    @current_tabstop = block.text.last
    @current_tabstop[:tab_stop] = 0
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
  ensure
    @lines.rewind
  end

  def parse_title
    get_title or warn "reached end of document without finding title!"
    @output_directory = "man#{@manual_section.downcase}" if @manual_section
    @state[:title_parsed] = true

    # try to reset document state, in case we had some monkey business
    # before finding .TH
    @document = []
    source_init(titled: true)
  end
end
