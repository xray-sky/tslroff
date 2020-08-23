# troff.rb
# ---------------
#    troff main
# ---------------
#

require 'selenium-webdriver'

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

    xinit_selenium
    xinit_ec
    xinit_in
    xinit_nr

    self.methods.each do |m|
      self.send(m) if m.to_s.match(/^init_/)
    end

  end

  def to_html
    @current_block = blockproto
    @document << @current_block
    loop do
      begin
        l = @lines.tap { @register['.c'].value += 1 }.next
        parse(l)
      rescue StopIteration
        # TODO: perform end-of-input trap macros from .em;
        # REVIEW: maybe make the closing divs happen that way. or clean up the way the open divs get inserted.
        #@webdriver.quit
        return @document.collect(&:to_html).join + "\n    </div>\n</div>" # REVIEW: closes main doc divs start ed by :th
      rescue => e
        warn "#{l.inspect} -"
        warn e
        warn e.backtrace.join("\n")
      end
    end
  end

  def input_line_number
    @register['.c'].value
  end

  def self.related_info_heading
    %r(SEE(?: |&nbsp;)ALSO)
  end

  private

  # prototype a new block with whatever necessary styles carried forward.
  def blockproto(type = :p)
    block = Block.new(type: type)
    block.style[:section] = @state[:section] if @state[:section]
    block.style.css[:margin_top] = nofill? ? '0' : ("#{to_em(@register[')P'].value.to_s + 'u')}em" unless @register[')P'].value == @state[:default_pd])
    block.style.css[:margin_left] = "#{to_em(@register['.i'].value.to_s + 'u')}em" unless @register['.i'].value == @base_indent
    @current_tabstop = block.text.last
    @current_tabstop[:tab_stop] = 0
    block
  end
end
