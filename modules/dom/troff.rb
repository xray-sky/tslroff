# troff.rb
# ---------------
#    troff main
# ---------------
#

require 'selenium-webdriver'

class Manual
  def self.related_info_heading
    %r(SEE(?: |&nbsp;)ALSO)
  end
end

module Troff

  @@delim = %(\002\003\005\006\007"')

  def source_init
    %w[. request macro escape].each do |t|
      Dir.glob("#{File.dirname(__FILE__)}/troff/#{t}/*.rb").each do |i|
        require i
      end
    end

    @register = Hash.new
    @state    = Hash.new

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
      self.send(m) if m.to_s.match(/^init_/)
    end

  end

  def to_html
    @current_block = blockproto
    @document << @current_block
    loop do
      begin
        l = @lines.tap { @register['.c'].incr }.next
        parse(l)
      rescue StopIteration
        # TODO: perform end-of-input trap macros from .em;
        @current_block = Block.new
        @document << @current_block
        @current_block.style.attributes[:class] = 'foot'
        #@current_block << '&ensp;&ensp;&mdash;&ensp;&ensp;'
        unescape(@state[:footer])
        #@current_block << '&ensp;&ensp;&mdash;&ensp;&ensp;'
        # REVIEW: maybe make the closing divs happen that way. or clean up the way the open divs get inserted.
        return @document.collect(&:to_html).join + "\n    </div>\n</div>" # REVIEW: closes main doc divs start ed by :th
      rescue => e
        warn "#{l.inspect} -"
        warn e
        warn e.backtrace.join("\n")
      end
    end
  end

  def input_line_number
    @register['.c']&.value || 0
  end

  def debug(line, *msg)
    warn (['debug: ']+(msg.collect(&:inspect))).join(' ') if input_line_number == line
  end

  private

  # prototype a new block with whatever necessary styles carried forward.
  def blockproto(type = :p)
    break_adj # eat a break at the end of a block; this wouldn't have whitespaced. but html will REVIEW is this working??
    type = :cs if @state[:cs]
    block = Block.new(type: type)
    block.style[:section] = @state[:section] if @state[:section]
    block.style.css[:margin_top] = "#{to_em(@register[')P'].to_s)}em" unless @register[')P'] == @state[:default_pd]
    block.style.css[:margin_top] = '0' if nospace? #if nofill? or nospace?
    block.style.css[:margin_left] = "#{to_em(@register['.i'].to_s)}em"
    block.style.css.delete(:margin_left) if @register['.i'] == @state[:base_indent]
    block.style.css[:text_align] = [ 'left', 'justify', nil, 'center', nil, 'right' ][@register['.j']] unless @register['.j'] == 1
    block.style.css[:text_align] = 'left' if noadj?		# .na sets left adjust without changing .j
    @current_tabstop = block.text.last
    @current_tabstop[:tab_stop] = 0
    block
  end
end
