# troff.rb
# ---------------
#    troff main
# ---------------
#

module Troff

  def source_init
    %w[. request macro escape].each do |t|
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
        l = @lines.tap { @state[:register]['.c'].value += 1 }.next
        parse(l.rstrip)
      rescue StopIteration
        @document << @current_block
        return @document.collect(&:to_html).join
      end
    end
  end

end
